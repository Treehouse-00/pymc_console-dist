# OpenHop Console

[![GitHub Release](https://img.shields.io/github/v/release/matthew73210/pymc_console-dist)](https://github.com/matthew73210/pymc_console-dist/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A wrapper installer and real-time web dashboard for [OpenHop Repeater](https://github.com/openhop-dev/openhop_repeater) and [MeshCore](https://meshcore.io/) LoRa mesh networks.

This repo installs the OpenHop backend and the Console dashboard together. It does not fork or modify OpenHop protocol, radio logic, packet formats, or MeshCore internals.

## What It Installs

`manage.sh install` installs both parts of the stack:

| Component | Installed by this wrapper |
| --- | --- |
| OpenHop Repeater backend | cloned from `openhop-dev/openhop_repeater`, installed into `/opt/openhop_repeater` |
| Repeater config | `/etc/openhop_repeater/config.yaml` |
| Repeater service | `openhop-repeater.service` |
| Console dashboard assets | `/opt/openhop_console/web/html` |
| Web path patch | `web.web_path: /opt/openhop_console/web/html` |

The wrapper also installs Debian packages needed for the backend and dashboard, creates the `repeater` service user, enables/starts systemd, and prints the LAN URL.

## Quick Start: Debian LXC

1. Create a plain Debian LXC, for example with the Community Scripts / Proxmox VE Helper Scripts Debian template:

   <https://community-scripts.org/scripts?q=debian>

2. Install the minimum tools needed to fetch this wrapper:

   ```bash
   apt update
   apt install -y git ca-certificates
   ```

3. Clone and run the wrapper:

   ```bash
   git clone https://github.com/matthew73210/pymc_console-dist.git openhop_console
   cd openhop_console
   ./manage.sh install
   ```

If you are not root, `manage.sh` re-runs itself with `sudo` when available. If neither root nor `sudo` is available, run the command as root.

4. Open the dashboard:

   ```text
   http://<lxc-ip>:8000/
   ```

Fresh installs start in OpenHop's no-radio mode (`radio_type: null`) so the web UI can come up before serial/SPI hardware is passed through and configured.

## Verification

After install:

```bash
test -d /opt/openhop_repeater
test -f /etc/openhop_repeater/config.yaml
test -d /opt/openhop_console/web/html
systemctl status openhop-repeater --no-pager
ss -ltnp | grep ':8000'
grep -R "/opt/openhop_console/web/html" /etc/openhop_repeater/config.yaml
```

OpenHop Repeater's web server defaults to `0.0.0.0:8000`, so it is reachable outside the container when the LXC network and firewall allow it.

## Management

```bash
./manage.sh --help
```

| Verb | Action |
| --- | --- |
| `install` | Install Debian dependencies, OpenHop Repeater, systemd service, config, Console assets, and `web.web_path`. |
| `upgrade` | Update/reinstall OpenHop Repeater from the configured upstream ref and refresh Console assets. |
| `uninstall` | Remove Console assets and this wrapper checkout. It intentionally does not remove OpenHop Repeater. |

Useful overrides:

```bash
OPENHOP_REPEATER_REPO=https://github.com/openhop-dev/openhop_repeater.git
OPENHOP_REPEATER_REF=main
OPENHOP_REPEATER_SOURCE_DIR=/opt/openhop_repeater/source
OPENHOP_CONSOLE_DIR=/opt/openhop_console
OPENHOP_CONSOLE_REPO=matthew73210/pymc_console-dist
OPENHOP_UI_TARBALL=openhop-console-ui-latest.tar.gz
```

Legacy `PYMC_*` environment variables are still accepted with a deprecation warning.

## Service Commands

```bash
systemctl status openhop-repeater --no-pager
journalctl -u openhop-repeater -f
systemctl restart openhop-repeater
```

The active config file is:

```text
/etc/openhop_repeater/config.yaml
```

The wrapper patches:

```yaml
web:
  web_path: /opt/openhop_console/web/html
```

## Proxmox LXC Serial Notes

USB and serial devices must be passed from the Proxmox host into the LXC. The exact device depends on your radio/modem.

Example host-side passthrough using a stable by-id path:

```bash
ls -l /dev/serial/by-id/
pct set <CTID> -mp0 /dev/serial/by-id/<device-id>,mp=/dev/serial/by-id/<device-id>
```

If you pass a raw device instead:

```bash
pct set <CTID> -mp0 /dev/ttyACM0,mp=/dev/ttyACM0
# or
pct set <CTID> -mp0 /dev/ttyUSB0,mp=/dev/ttyUSB0
```

Inside the container:

```bash
ls -l /dev/ttyACM* /dev/ttyUSB* /dev/serial/by-id/* 2>/dev/null
id repeater
usermod -aG dialout,plugdev repeater
systemctl restart openhop-repeater
```

For USB/CDC serial modems, `dialout` is normally required. `plugdev` is commonly useful for udev-managed devices. GPIO/SPI radios may also need host-side device passthrough and matching groups such as `gpio`, `i2c`, or `spi`. Udev rules for physical USB adapters belong on the Proxmox host, not only inside the container.

## Directory Layout

```text
~/openhop_console/                   this wrapper checkout
/opt/openhop_repeater/source/        upstream OpenHop Repeater source checkout
/opt/openhop_repeater/venv/          backend Python virtual environment
/etc/openhop_repeater/config.yaml    repeater config
/var/lib/openhop_repeater/           repeater runtime data
/var/log/openhop_repeater/           repeater logs
/opt/openhop_console/web/html/       installed Console dashboard
```

Legacy installs under `/opt/pymc_console` are migrated automatically when possible. Legacy Repeater data under `/opt/pymc_repeater`, `/etc/pymc_repeater`, `/var/lib/pymc_repeater`, and `/var/log/pymc_repeater` is migrated into OpenHop paths during wrapper install.

## Advanced: Upstream Repeater Only

This is not the normal install path for this wrapper. Use it only to debug upstream OpenHop Repeater independently of the Console wrapper:

```bash
git clone https://github.com/openhop-dev/openhop_repeater.git
cd openhop_repeater
./manage.sh install
```

After using the upstream-only installer, you can return to this wrapper and run:

```bash
cd ~/openhop_console
./manage.sh install
```

## Troubleshooting

If the dashboard is not reachable from another machine:

```bash
hostname -I
systemctl status openhop-repeater --no-pager
ss -ltnp | grep ':8000'
journalctl -u openhop-repeater -n 100
```

If serial access fails:

```bash
ls -l /dev/ttyACM* /dev/ttyUSB* /dev/serial/by-id/* 2>/dev/null
id repeater
journalctl -u openhop-repeater -n 100 | grep -Ei 'serial|tty|permission|radio|error'
```

Fix host passthrough first, then confirm the `repeater` user is in the needed groups inside the container.

## Verified Naming

The upstream pyMC project was renamed to OpenHop. Verified current upstream names:

| Surface | Current name |
| --- | --- |
| Repeater repository | `https://github.com/openhop-dev/openhop_repeater` |
| Repeater Python distribution | `openhop_repeater` |
| Repeater command | `openhop-repeater` |
| Repeater service | `openhop-repeater.service` |
| Repeater install path | `/opt/openhop_repeater` |
| Repeater config path | `/etc/openhop_repeater/config.yaml` |
| Core repository | `https://github.com/openhop-dev/openhop_core` |

Compatibility note: the current `openhop_core` repository still exposes its Python project/import as `pymc_core` in upstream metadata. This repo leaves that as an upstream compatibility detail instead of guessing a rename that is not currently published.
