# OpenHop Console

[![GitHub Release](https://img.shields.io/github/v/release/matthew73210/pymc_console-dist)](https://github.com/matthew73210/pymc_console-dist/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A real-time web dashboard for [MeshCore](https://meshcore.io/) LoRa mesh repeaters.

OpenHop Console gives you visibility into packet flow, topology, signal quality, RF metrics, and radio configuration through a browser tab. It is a wrapper-only dashboard overlay for [OpenHop Repeater](https://github.com/openhop-dev/openhop_repeater); it does not modify OpenHop protocol, radio logic, packet formats, or MeshCore internals.

## What Changed

The upstream pyMC project was renamed to OpenHop. The old wrapper still looked for pyMC install paths, package names, config directories, and systemd service names, so a fresh OpenHop Repeater install was reported as missing and `web.web_path` was patched in the wrong config file.

Verified current upstream names:

| Surface | Current name |
| --- | --- |
| Repeater repository | `https://github.com/openhop-dev/openhop_repeater` |
| Repeater Python distribution | `openhop_repeater` |
| Repeater command | `openhop-repeater` |
| Repeater service | `openhop-repeater.service` |
| Repeater install path | `/opt/openhop_repeater` |
| Repeater config path | `/etc/openhop_repeater/config.yaml` |
| Repeater data path | `/var/lib/openhop_repeater` |
| Repeater log path | `/var/log/openhop_repeater` |
| Core repository | `https://github.com/openhop-dev/openhop_core` |

Compatibility note: the current `openhop_core` repository still exposes its Python project/import as `pymc_core` in upstream metadata. This repo leaves that as a documented upstream compatibility detail instead of guessing a rename that is not currently published.

## Quick Start

### Debian LXC

This is the recommended target for this wrapper.

1. Create a plain Debian LXC, for example with the Community Scripts / Proxmox VE Helper Scripts Debian template:

   <https://community-scripts.org/scripts?q=debian>

2. Install the usual base tools inside the container:

   ```bash
   apt update
   apt install -y git curl ca-certificates python3 python3-pip python3-venv yq
   ```

3. Install upstream OpenHop Repeater inside the LXC:

   ```bash
   git clone https://github.com/openhop-dev/openhop_repeater.git
   cd openhop_repeater
   sudo ./manage.sh install
   ```

4. Install this Console wrapper:

   ```bash
   git clone https://github.com/matthew73210/pymc_console-dist.git openhop_console
   cd openhop_console
   sudo bash manage.sh install
   ```

5. Open the dashboard from another machine on the LAN:

   ```text
   http://<lxc-ip>:8000/
   ```

OpenHop Repeater's web server defaults to `0.0.0.0:8000`, so it is reachable outside the container when the LXC network and firewall allow it.

### Raspberry Pi Or Other Debian Hosts

The wrapper flow is the same: install OpenHop Repeater first, then run this repo's `manage.sh install`. Upstream OpenHop Repeater owns radio setup, GPIO, service management, logs, and upgrades.

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

Inside the container, verify the device and permissions:

```bash
ls -l /dev/ttyACM* /dev/ttyUSB* /dev/serial/by-id/* 2>/dev/null
getent group dialout
id repeater
sudo usermod -aG dialout,plugdev repeater
sudo systemctl restart openhop-repeater
```

For USB/CDC serial modems, `dialout` is normally required. `plugdev` is commonly useful for udev-managed devices. GPIO/SPI radios may also need host-side device passthrough and matching groups such as `gpio`, `i2c`, or `spi`; OpenHop Repeater's installer handles its service user, but an unprivileged LXC still needs the host devices made visible first. Udev rules for physical USB adapters belong on the Proxmox host, not only inside the container.

## Management

`manage.sh` is Console-only.

```bash
sudo bash manage.sh --help
```

| Verb | Action |
| --- | --- |
| `install` | Install the Console dashboard into `/opt/openhop_console` and point `web.web_path` at it. Requires OpenHop Repeater. |
| `upgrade` | Refresh dashboard assets in place. Preserves `web_path`, except it migrates the old `/opt/pymc_console/web/html` path to `/opt/openhop_console/web/html`. |
| `uninstall` | Remove the Console dashboard and this wrapper checkout. Does not remove OpenHop Repeater. |

Flags:

```bash
sudo bash manage.sh --yes install
ASSUME_YES=1 sudo -E bash manage.sh upgrade
```

Environment overrides:

```bash
OPENHOP_CONSOLE_DIR=/opt/openhop_console
OPENHOP_CONSOLE_REPO=matthew73210/pymc_console-dist
OPENHOP_UI_TARBALL=openhop-console-ui-latest.tar.gz
```

Legacy `PYMC_*` environment variables are still accepted with a deprecation warning.

## Service Commands

Service lifecycle belongs to OpenHop Repeater:

```bash
sudo systemctl enable --now openhop-repeater
sudo systemctl status openhop-repeater
sudo journalctl -u openhop-repeater -f
sudo systemctl restart openhop-repeater
```

The active config file is:

```text
/etc/openhop_repeater/config.yaml
```

The wrapper patches only:

```yaml
web:
  web_path: /opt/openhop_console/web/html
```

## Directory Layout

```text
~/openhop_console/                   this wrapper checkout
~/openhop_repeater/                  upstream OpenHop Repeater source
/opt/openhop_repeater/               installed repeater
/etc/openhop_repeater/config.yaml    repeater config
/var/lib/openhop_repeater/           repeater runtime data
/var/log/openhop_repeater/           repeater logs
/opt/openhop_console/web/html/       installed Console dashboard
```

Legacy installs under `/opt/pymc_console` are migrated automatically when possible. Legacy Repeater installs under `/opt/pymc_repeater` are detected so existing users can still refresh the dashboard, but new installs should use OpenHop Repeater.

## Manual Update

Update OpenHop Repeater with upstream's manager:

```bash
cd ~/openhop_repeater
sudo ./manage.sh upgrade
```

Update this Console wrapper:

```bash
cd ~/openhop_console
sudo bash manage.sh upgrade
```

## Troubleshooting

If the dashboard is not reachable from another machine:

```bash
hostname -I
sudo systemctl status openhop-repeater
sudo ss -ltnp | grep ':8000'
sudo journalctl -u openhop-repeater -n 100
```

Confirm the service is listening on `0.0.0.0:8000` or the LXC IP, not only `127.0.0.1`, and check Proxmox firewall rules plus any firewall inside Debian.

If serial access fails:

```bash
ls -l /dev/ttyACM* /dev/ttyUSB* /dev/serial/by-id/* 2>/dev/null
id repeater
sudo journalctl -u openhop-repeater -n 100 | grep -Ei 'serial|tty|permission|radio|error'
```

Fix the host passthrough first, then make sure the `repeater` user is in the needed groups inside the container.

## Features

- Topology analysis from packet paths, including confidence scoring and ghost-node discovery.
- Link-quality radar for direct RF neighbors.
- Statistics dashboards for airtime, packet type distribution, noise floor, and network composition.
- Packet path tracing with hop-by-hop signal details.
- Live logs, terminal controls, configuration views, and telemetry pages.

## Credits

- [OpenHop Repeater](https://github.com/openhop-dev/openhop_repeater) - repeater daemon.
- [OpenHop Core](https://github.com/openhop-dev/openhop_core) - MeshCore Python library repository.
- [MeshCore](https://meshcore.io/) - underlying mesh protocol ecosystem.
