# Installing waev:outpost

This guide covers **manual** installation of the waev:outpost dashboard (without `manage.sh`). For the standard installer workflow, see [README.md](README.md).

## Prerequisite

An existing [openHop Repeater](https://github.com/openhop-dev/openhop_repeater) installation, 1.1 or newer; the console tracks the Repeater's `dev` branch and is checked against it before each release (see the README's Repeater compatibility section for what it reads and what it tolerates). waev:outpost is served by openHop Repeater's CherryPy server; installing it on its own does nothing useful.

Verify Repeater is installed:

```bash
ls /opt/openhop_repeater/pyproject.toml
```

On a system that still runs the pyMC-era layout (`/opt/pymc_repeater`, `/etc/pymc_repeater/config.yaml`, the `pymc-repeater` service), `manage.sh` detects it and patches that config file instead. openHop Repeater's own `manage.sh` migrates those paths to the openHop ones and retires the `pymc-repeater` service the next time you run its install or upgrade, and the Console's `web_path` setting moves with the config. The paths below are the current openHop ones.

---

## Using manage.sh (Recommended)

```bash
git clone --depth 1 --single-branch --branch main --no-tags \
  https://github.com/Treehouse-00/pymc_console-dist.git pymc_console
cd pymc_console
sudo ./manage.sh install
```

Use the shallow public distribution clone to avoid downloading historical UI
builds. The installer downloads the current UI release separately. This does
not remove objects already downloaded by an existing full clone; re-clone once
after the latest-only migration to reclaim that space.

This downloads the latest waev:outpost release, extracts to `/opt/pymc_console/web/html`, and — on a fresh install, when `yq` is present — patches `web.web_path` in `/etc/openhop_repeater/config.yaml`. Without `yq` the dashboard is still installed and the installer prints the command to run by hand. See [README.md](README.md) for all commands.

---

## Manual Install (no manage.sh)

If you don't want to clone this repo, install the release tarball directly:

```bash
# 1. Download the latest waev:outpost release
cd /tmp
wget https://github.com/Treehouse-00/pymc_console-dist/releases/latest/download/pymc-ui-latest.tar.gz

# 2. Extract to /opt/pymc_console/web/html (the waev:outpost install target)
sudo mkdir -p /opt/pymc_console/web/html
sudo tar -xzf pymc-ui-latest.tar.gz -C /opt/pymc_console/web/html/

# 3. Set ownership to the repeater service user
sudo chown -R repeater:repeater /opt/pymc_console

# 4. Point openHop Repeater at the dashboard (one-time)
#    Open /etc/openhop_repeater/config.yaml and set:
#      web:
#        web_path: /opt/pymc_console/web/html
#    Or, if you have `yq` installed:
sudo yq -i '.web.web_path = "/opt/pymc_console/web/html"' /etc/openhop_repeater/config.yaml

# 5. Restart the repeater service
sudo systemctl restart openhop-repeater

# 6. Clean up
rm /tmp/pymc-ui-latest.tar.gz
```

The dashboard is now served at `http://<your-pi-ip>:8000/`.

---

## Manual Update

To update an existing waev:outpost install without using `manage.sh`:

```bash
# Download latest version
cd /tmp
wget https://github.com/Treehouse-00/pymc_console-dist/releases/latest/download/pymc-ui-latest.tar.gz

# Backup existing dashboard
sudo cp -r /opt/pymc_console/web/html /opt/pymc_console/web/html.backup

# Replace contents (web_path is preserved since we keep the same directory)
sudo rm -rf /opt/pymc_console/web/html/*
sudo tar -xzf pymc-ui-latest.tar.gz -C /opt/pymc_console/web/html/
sudo chown -R repeater:repeater /opt/pymc_console

# Clean up
rm /tmp/pymc-ui-latest.tar.gz
```

No service restart is required for asset-only updates — clients will pick up the new bundle on next page load. Hard-refresh (`Cmd+Shift+R` / `Ctrl+Shift+R`) if stale.

---

## Only the latest release is published

Each release replaces the previous one on the distribution repository: the
sync workflow deletes every older release and tag, so there is no versioned
download to pin and no way to install an earlier UI. The current release does
carry a `pymc-ui-v<tag>` archive, but it disappears with the release it belongs
to. `releases/latest/download/` is the only supported source.

---

## Uninstall

```bash
sudo rm -rf /opt/pymc_console

# Clear web.web_path yourself when it still points at the dashboard you just
# removed, so the Repeater falls back to upstream's Vue.js dashboard instead of
# serving nothing. A value you set by hand to something else is left for you to
# change. (`manage.sh uninstall` does this step for you.)
sudo yq -i 'del(.web.web_path)' /etc/openhop_repeater/config.yaml

sudo systemctl restart openhop-repeater
```

openHop Repeater itself is not affected.
