# waev:outpost Release Guide

Complete guide for developers to create and publish new releases of waev:outpost.

## Table of Contents
- [Quick Release Steps](#quick-release-steps)
- [Understanding the Release Process](#understanding-the-release-process)
- [Manual Build Process](#manual-build-process)
- [Troubleshooting](#troubleshooting)
- [Version Numbering](#version-numbering)

---

## Quick Release Steps

Run the repository-owned release command from the project root. Patch is the
default; use `minor` or `major` only when the release explicitly requires it.

```bash
./release.sh "feat: concise release subject"
```

Write the full operator-facing notes in `CHANGELOG.md` first. The script
fetches `origin/main` and aborts before touching anything if that ref is not an
ancestor of `HEAD` (Step 0), runs the public distribution gates and refuses to
release if they fail (Step 0.5), validates source, commits source without generated
`dist/`, bumps the version, inserts a one-line `CHANGELOG.md` stanza only when
the new version has none (Step 3.5), rebuilds the bundle with that final
version, commits `dist/` with the version files, then tags and pushes `HEAD` to
`origin/main`. Only `patch`, `minor`, and `major` are accepted.

---

## Understanding the Release Process

### What Happens Automatically

This project uses **GitHub Actions** for continuous integration and deployment:

#### In the Private Source Repository:
- In the private source repository, `build-ui.yml` verifies and uploads the
  committed `frontend/dist/` package and tests the distribution workflow.
- In the public distribution repository, `build-ui.yml` validates the installer
  and rejects tracked `frontend/dist/` files; it does not upload a UI artifact.
- A normal branch push does not change the public distribution repository.

#### On Version Tag Push (for example `v0.9.356`):
- `sync-to-public.yml` rebuilds the UI outside Git and writes installer files,
  version metadata, and documentation to a new parentless commit.
- It runs once per public repository, in parallel (a job matrix): the console
  target publishes the UI archives to `Treehouse-00/pymc_console-dist`, and the
  plugin target builds the openHop plugin wheel (`npm run build:plugin`) and
  publishes it as the single `.whl` asset on `Treehouse-00/waev-outpost-plugin`.
  Both repositories receive the same one-commit snapshot; the plugin one also
  carries `openhop-plugin.json`. `PUBLIC_REPO_TOKEN` must be able to push to both.
- `./release.sh "…" --targets=plugin` (or `--targets=console`) narrows a
  release to one repository. The flag is written to the `PUBLISH_TARGETS`
  repository variable before the tag is pushed, and rewritten to the default
  `console,plugin` on every run without the flag, so a narrowed release never
  carries into the next one. The other repository keeps its previous release.
- The console distribution remains latest-only: public `main` is replaced and
  older console tags/releases are deleted after the new release is live.
- Plugin releases are immutable and retained. Exact versioned wheel URLs in the
  catalogue must remain downloadable for approved installs and rollbacks.
- After a successful public sync, `propose-plugin-catalogue.yml` downloads the
  published wheel, validates its RECORD and embedded metadata, hashes those exact
  bytes, and opens or updates a version-specific draft PR against
  `openhop-dev/openhop-plugin-catalogue`. A human still decides whether to merge.
  `OPENHOP_CATALOGUE_TOKEN` must be a fine-grained token limited to that one
  catalogue repository with Contents read/write, Pull requests read/write, and
  Metadata read-only. The workflow derives commit identity from the token's user
  instead of hard-coding a maintainer.
- The hard postcondition requires one root commit, one `main` branch, the current
  tag/latest release, and no tracked `frontend/dist/` tree. The plugin target may
  also retain older tags and releases.

Generated UI files belong in release assets, not the public repository's Git
history. The sync builds a fresh one-commit repository, keeps staged UI and
archives outside that checkout, and scans both metadata and staged UI for secrets
before publishing. Documentation is internal by default: only `docs/images`
crosses over, by allowlist, and the sync aborts before pushing if anything else
under `docs/` reached the staged tree. End-user clone examples retain `--depth 1
--single-branch --branch main --no-tags` as a defense-in-depth bound.

Do **not** enable GitHub's repository-level immutable-release setting on the
console distribution repository; its latest-only policy intentionally replaces
the current release. The plugin release workflow rejects reuse of an existing
published release and retains all published versions. If a failed publication
left only an orphan tag with no release, the next run removes that unusable tag
and retries the same version safely.

The private source repository's committed build and local release process are
unchanged. For branch-only UI builds, use the private manual artifact workflow.

Run the distribution regression checks locally with:

```bash
node --test scripts/public-distribution.test.mjs
```

`release.sh` runs that same command at Step 0.5, before anything is committed or
tagged, and aborts the release when it fails. The tag push starts the public
sync, and that workflow does not wait for Build Validation, so a gate that only
runs in CI would be advisory at release time.

### The Workflow File

The relevant workflows are `.github/workflows/build-ui.yml`,
`.github/workflows/build-ui-artifact.yml`,
`.github/workflows/sync-to-public.yml`, and
`.github/workflows/propose-plugin-catalogue.yml`.

The catalogue proposal workflow can be retried without rebuilding or replacing a
release: run **Propose waev:outpost catalogue update** manually and enter its existing
`vMAJOR.MINOR.PATCH` tag. If that tag has no waev:outpost wheel release, the workflow
exits successfully without creating a catalogue branch or PR.

---

## Detailed Release Steps

1. Finish and review the source changes on a branch based on `origin/main`.
2. Add a dated section for the next version to `CHANGELOG.md`. Write it by
   hand: if the script finds no `## [X.Y.Z]` heading for the new version, its
   Step 3.5 inserts a placeholder stanza (dated today, sectioned by the commit
   type, one bullet from the commit subject) so the in-app "What's new" reader
   never falls behind. That stanza is a fallback, not release notes.
3. Run the required tests, typecheck, and production build proof.
4. Run `./release.sh "type: concise subject" [patch|minor|major]`. Its Step 0
   preflight fetches `origin/main` and aborts, before any commit or tag exists,
   when `origin/main` is not an ancestor of `HEAD` (see Troubleshooting).
5. Verify the new tag and `origin/main`, then monitor both build and public-sync
   workflows. Confirm the published archive and release notes match the tag.

Do not run `npm version` and push tags by hand unless `release.sh` is
unavailable. The script's ordering is what prevents the final JavaScript bundle
from embedding the previous version number.

---

## Manual Build Process

If you need to build locally without creating a release:

```bash
cd pymc_console/frontend

# Install dependencies (first time only). The Motion+ token must be injected
# into the __MOTION_TOKEN__ placeholders first — see README.md, "Development".
npm install

# Build static files
npm run build:static
```

The output will be in `frontend/dist/` directory.

### What the Build Does

1. `vite build` - Compiles React app to static HTML/CSS/JS
2. Outputs to `frontend/out/`
3. `scripts/precompress-assets.mjs` writes `.br` and `.gz` sidecars beside the
   compressible files in `out/`
4. `npm run package` copies `out/` contents to `frontend/dist/`

---

## Troubleshooting

### "Release job was skipped"

**Problem:** You pushed code but no GitHub Release was created.

**Solution:** Public release publishing only runs for version tags. Confirm that
`release.sh` completed, that its `vX.Y.Z` tag exists on origin, and that the
matching `sync-to-public.yml` run was not cancelled or superseded.

### "origin/main has moved ahead of this branch"

**Problem:** `release.sh` stopped at Step 0 because `origin/main` contains
commits that `HEAD` does not.

**Solution:** Nothing was committed, tagged, or pushed. Run
`git fetch origin main && git rebase origin/main`, resolve any conflicts, and
rerun the same release command.

### "Build failed: npm ERR! code ELIFECYCLE"

**Problem:** The build process failed.

**Solution:** 
1. Pull the latest code: `git pull origin main`
2. Clean install locally: `cd frontend && rm -rf node_modules && npm install` (keep
   `package-lock.json` — it is tracked, and it carries the tokenised `motion-plus`
   resolution)
3. Test build locally: `npm run build:static`
4. Fix any errors before pushing

### "Tag already exists"

**Problem:** You tried to create a tag that already exists.

**Solution:** Stop and inspect the existing local tag, remote tag, and release.
Do not rewrite a published tag. If the tag is only local and no release was
published, remove that local tag after confirming its exact target, then rerun
the canonical release command with the intended version.

### "Permission denied" when creating release

**Problem:** GitHub Actions doesn't have permission to create releases.

**Solution:** Releases are created on the distribution repository with the
`PUBLIC_REPO_TOKEN` PAT, not with the run's `GITHUB_TOKEN`, so the source
repository's "Workflow permissions" setting does not govern them. Check that the
`PUBLIC_REPO_TOKEN` secret on the `.console.env` environment still exists, has
not expired, and still carries `repo` scope on the distribution repository.

---

## Version Numbering

### Semantic Versioning Format

`MAJOR.MINOR.PATCH` (e.g., `0.1.2`)

### When to Increment Each Part

| Change Type | Example | Command | Version Change |
|-------------|---------|---------|----------------|
| Bug fix | Fix broken map display | `./release.sh "fix: …" patch` | `0.1.1` → `0.1.2` |
| New feature | Add dark mode | `./release.sh "feat: …" minor` | `0.1.2` → `0.2.0` |
| Breaking change | Require new API version | `./release.sh "feat: …" major` | `0.2.0` → `1.0.0` |

### Pre-releases

Not supported. `release.sh` rejects any bump type other than `patch`, `minor`,
or `major`, and `sync-to-public.yml` has no pre-release path: every tag push
replaces the single public release.

---

## End User Deployment

Once a release is published, end users can deploy it. Only the latest release
exists on the distribution repository (the sync workflow deletes every older
release and tag), so there is no versioned download to pin.

### Download and Extract

```bash
# Download the latest release
wget https://github.com/Treehouse-00/pymc_console-dist/releases/latest/download/pymc-ui-latest.tar.gz

# Extract to the waev:outpost install target
sudo mkdir -p /opt/pymc_console/web/html
sudo tar -xzf pymc-ui-latest.tar.gz -C /opt/pymc_console/web/html/

# Or use zip (pymc-ui-latest.zip is published alongside the tarball)
sudo unzip pymc-ui-latest.zip -d /opt/pymc_console/web/html/
```

### Configure Backend

openHop Repeater serves these static files when `web.web_path` in
`/etc/openhop_repeater/config.yaml` points at `/opt/pymc_console/web/html`.
`manage.sh install` sets it on a fresh install; INSTALL.md covers the manual
steps.

---

## Quick Reference Commands

```bash
# View current version
cat frontend/package.json | grep version

# List all tags
git tag --list

# View latest tag
git describe --tags --abbrev=0

# Delete local tag
git tag -d v0.1.2

# Delete remote tag
git push origin :refs/tags/v0.1.2

# Create tag manually (if npm version didn't work)
git tag v0.1.2
git push origin v0.1.2

# Check GitHub Actions status
# Visit: https://github.com/Treehouse-00/pymc_console/actions
```

---

## Need Help?

- Check GitHub Actions logs for detailed error messages
- Review commit messages to ensure they follow conventions
- Test builds locally before pushing tags
- Ask in the project's discussion forum or issues section
