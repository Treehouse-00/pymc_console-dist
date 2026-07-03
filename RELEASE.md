# OpenHop Console Release Process

This repository is the distribution wrapper for OpenHop Console. A fresh install expects a release asset named:

```text
openhop-console-ui-latest.tar.gz
```

`manage.sh install` downloads that asset from the latest GitHub Release, validates it, installs it into `/opt/openhop_console/web/html`, patches `/etc/openhop_repeater/config.yaml`, and restarts `openhop-repeater.service`.

## Build And Publish The Dashboard

Use GitHub Actions:

1. Open `Actions` -> `Build and Release OpenHop Console UI`.
2. Run the workflow manually.
3. Use the default source unless you intentionally override it:

   ```text
   source_repo: openhop-dev/openHop_RepeaterUI
   source_ref: main
   source_path: .
   build_command: npm run build
   release_tag: latest
   ```

The workflow checks out this wrapper plus the UI source repository, runs `scripts/prepare-openhop-ui-source.sh`, builds the static UI, validates the output with `scripts/validate-ui-assets.sh`, packages `openhop-console-ui-latest.tar.gz`, extracts and validates the tarball again, then uploads it to the selected GitHub Release.

The legacy `pymc-ui-latest.tar.gz` asset is optional and should only be uploaded when needed for old installers. It is copied from the same validated OpenHop bundle.

## Source Repository Note

This distribution repository does not contain a complete frontend source tree; its local `frontend/dist` is a fallback only. The public OpenHop UI source identified for the release workflow is:

```text
https://github.com/openhop-dev/openHop_RepeaterUI
```

If a different canonical UI source is restored later, set `source_repo`, `source_ref`, and `source_path` in the workflow dispatch inputs instead of editing the installer.

## Local Checks

Before merging wrapper changes:

```bash
bash -n manage.sh
bash -n scripts/validate-ui-assets.sh
bash -n scripts/prepare-openhop-ui-source.sh
bash scripts/test-ui-asset-validation.sh
```

To confirm the bundled fallback is not stale:

```bash
bash scripts/validate-ui-assets.sh frontend/dist "local frontend/dist"
```

That command must pass before local `frontend/dist` can be used as an installer fallback. Stale pyMC-branded assets must not be published or installed.

## Install Verification

On a clean Debian LXC or Debian host:

```bash
apt update
apt install -y git ca-certificates
cd /opt
git clone https://github.com/matthew73210/pymc_console-dist.git openhop_console
cd openhop_console
./manage.sh --yes install
```

Confirm the wrapper installed both OpenHop Repeater and the Console dashboard:

```bash
test -d /opt/openhop_repeater
test -f /etc/openhop_repeater/config.yaml
test -d /opt/openhop_console/web/html
systemctl status openhop-repeater --no-pager
ss -ltnp | grep ':8000'
grep -R '/opt/openhop_console/web/html' /etc/openhop_repeater/config.yaml
```

Then load:

```text
http://<host-or-lxc-ip>:8000/
```

## Compatibility Boundaries

Do not rename upstream `pymc_core`, `pymc_usb`, or `pymc_tcp` identifiers unless upstream publishes corresponding OpenHop package/API names. Those are backend compatibility details. Browser-visible pyMC branding, stale `/opt/pymc_*` paths, and stale `/etc/pymc_*` paths must be removed from release assets.
