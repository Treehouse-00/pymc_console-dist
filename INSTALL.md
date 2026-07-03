# Installing OpenHop Console

OpenHop Console is a wrapper installer. Its `manage.sh install` command installs and configures both:

- OpenHop Repeater backend
- OpenHop Console dashboard assets

You do not need to install `openhop-dev/openhop_repeater` separately for the normal install path.

## Normal Install: Debian LXC

Start from a fresh Debian LXC.

Install only the minimum tools needed to fetch this wrapper:

```bash
apt update
apt install -y git ca-certificates
```

Clone and run this wrapper:

```bash
cd /opt
git clone https://github.com/matthew73210/pymc_console-dist.git openhop_console
cd openhop_console
./manage.sh install
```

If you are not root, `manage.sh` re-runs itself with `sudo` when available. If neither root nor `sudo` is available, run the command as root.

## What manage.sh install Does

The installer automatically:

- installs Debian packages needed by the wrapper and repeater,
- fetches `openhop-dev/openhop_repeater`,
- installs OpenHop Repeater into `/opt/openhop_repeater`,
- creates or updates `/etc/openhop_repeater/config.yaml`,
- installs, enables, and starts `openhop-repeater.service`,
- installs Console assets into `/opt/openhop_console/web/html`,
- patches `web.web_path` to `/opt/openhop_console/web/html`,
- restarts the repeater,
- prints the LAN URL.

Fresh installs start with `radio_type: null`, which lets the web UI come up before serial or SPI radio hardware is passed through and configured.

## Verify The Install

```bash
test -d /opt/openhop_repeater
test -f /etc/openhop_repeater/config.yaml
test -d /opt/openhop_console/web/html
systemctl status openhop-repeater --no-pager
ss -ltnp | grep ':8000'
grep -R "/opt/openhop_console/web/html" /etc/openhop_repeater/config.yaml
```

Open the dashboard at:

```text
http://<lxc-ip>:8000/
```

OpenHop Repeater listens on `0.0.0.0:8000` by default. If the UI is not reachable from the LAN, check the LXC network, Proxmox firewall rules, and any Debian firewall.

## Dashboard Asset Source

`manage.sh install` installs the backend and dashboard together. The dashboard files normally come from this repo's latest GitHub Release asset:

```text
openhop-console-ui-latest.tar.gz
```

The installer validates the archive before installing it into `/opt/openhop_console/web/html`. A legacy `pymc-ui-latest.tar.gz` archive is accepted only when it contains OpenHop-compatible assets. If release assets are missing, local `frontend/dist` is used only when it passes the same validation; stale pyMC-branded assets are refused.

Maintainers publish the release asset with the `Build and Release OpenHop Console UI` GitHub Actions workflow.

## Upgrade

```bash
cd openhop_console
./manage.sh upgrade
```

`upgrade` updates or reinstalls the OpenHop Repeater backend from the configured upstream ref and refreshes the Console dashboard assets.

## Useful Overrides

```bash
OPENHOP_REPEATER_REPO=https://github.com/openhop-dev/openhop_repeater.git
OPENHOP_REPEATER_REF=main
OPENHOP_REPEATER_SOURCE_DIR=/opt/openhop_repeater/source
OPENHOP_CONSOLE_DIR=/opt/openhop_console
OPENHOP_CONSOLE_REPO=matthew73210/pymc_console-dist
OPENHOP_UI_TARBALL=openhop-console-ui-latest.tar.gz
```

Legacy `PYMC_*` environment variables are still accepted for compatibility.

## Debian LXC Hardware Notes

Serial devices must be passed through from the Proxmox host before OpenHop Repeater can use real radio hardware.

Inside the LXC:

```bash
ls -l /dev/ttyACM* /dev/ttyUSB* /dev/serial/by-id/* 2>/dev/null
id repeater
usermod -aG dialout,plugdev repeater
systemctl restart openhop-repeater
```

Add `gpio`, `i2c`, or `spi` groups only when your passed-through radio hardware requires them.

## Uninstall Console Assets

```bash
rm -rf /opt/openhop_console
yq -i 'del(.web.web_path)' /etc/openhop_repeater/config.yaml
systemctl restart openhop-repeater
```

This removes the Console dashboard only. OpenHop Repeater itself is not removed.

## Advanced: Upstream Repeater Only

This is not the normal install path for this wrapper. Use it only when debugging upstream OpenHop Repeater independently of OpenHop Console.

The upstream repository currently includes its own `manage.sh`, but this wrapper does not require you to run it separately:

```bash
git clone https://github.com/openhop-dev/openhop_repeater.git
cd openhop_repeater
./manage.sh install
```

After debugging the upstream-only install, return to this wrapper and run:

```bash
cd openhop_console
./manage.sh install
```

## Legacy Notes

Older installs used `/opt/pymc_console`, `/etc/pymc_repeater/config.yaml`, and `pymc-repeater.service`. `manage.sh` detects and migrates those paths when possible, but new installs use OpenHop paths and `openhop-repeater.service`.
