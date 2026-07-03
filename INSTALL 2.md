# Installing OpenHop Console

This guide covers manual installation of the Console dashboard. For the normal workflow, use [README.md](README.md) and `manage.sh`.

## Prerequisite

Install upstream OpenHop Repeater first:

```bash
git clone https://github.com/openhop-dev/openhop_repeater.git
cd openhop_repeater
sudo ./manage.sh install
```

Verify the current OpenHop paths:

```bash
ls /opt/openhop_repeater/pyproject.toml
ls /etc/openhop_repeater/config.yaml
systemctl status openhop-repeater
```

## Using manage.sh

```bash
git clone https://github.com/matthew73210/pymc_console-dist.git openhop_console
cd openhop_console
sudo ./manage.sh install
```

This downloads the latest Console release, extracts it to `/opt/openhop_console/web/html`, and patches `web.web_path` in `/etc/openhop_repeater/config.yaml`.

## Manual Install

If you do not want to use `manage.sh`, install the release tarball directly:

```bash
cd /tmp
if wget https://github.com/matthew73210/pymc_console-dist/releases/latest/download/openhop-console-ui-latest.tar.gz; then
  archive=openhop-console-ui-latest.tar.gz
else
  wget https://github.com/matthew73210/pymc_console-dist/releases/latest/download/pymc-ui-latest.tar.gz
  archive=pymc-ui-latest.tar.gz
fi

sudo mkdir -p /opt/openhop_console/web/html
sudo tar -xzf "$archive" -C /opt/openhop_console/web/html/

sudo chown -R repeater:repeater /opt/openhop_console
sudo yq -i '.web.web_path = "/opt/openhop_console/web/html"' /etc/openhop_repeater/config.yaml
sudo systemctl restart openhop-repeater
```

The dashboard is served at:

```text
http://<host-or-lxc-ip>:8000/
```

## Manual Update

```bash
cd /tmp
if wget https://github.com/matthew73210/pymc_console-dist/releases/latest/download/openhop-console-ui-latest.tar.gz; then
  archive=openhop-console-ui-latest.tar.gz
else
  wget https://github.com/matthew73210/pymc_console-dist/releases/latest/download/pymc-ui-latest.tar.gz
  archive=pymc-ui-latest.tar.gz
fi

sudo cp -r /opt/openhop_console/web/html /opt/openhop_console/web/html.backup
sudo rm -rf /opt/openhop_console/web/html/*
sudo tar -xzf "$archive" -C /opt/openhop_console/web/html/
sudo chown -R repeater:repeater /opt/openhop_console
```

No service restart is required for asset-only updates. Hard-refresh the browser if it still shows a stale bundle.

## Debian LXC Checks

Inside a Proxmox Debian LXC:

```bash
hostname -I
sudo systemctl status openhop-repeater
sudo ss -ltnp | grep ':8000'
sudo journalctl -u openhop-repeater -f
```

OpenHop Repeater should listen on `0.0.0.0:8000` by default. If the UI is not reachable from the LAN, check Proxmox firewall rules, container networking, and any Debian firewall.

Serial devices must be passed through from the Proxmox host. Inside the LXC:

```bash
ls -l /dev/ttyACM* /dev/ttyUSB* /dev/serial/by-id/* 2>/dev/null
id repeater
sudo usermod -aG dialout,plugdev repeater
sudo systemctl restart openhop-repeater
```

Add `gpio`, `i2c`, or `spi` groups only when your passed-through radio hardware requires them.

## Uninstall

```bash
sudo rm -rf /opt/openhop_console
sudo yq -i 'del(.web.web_path)' /etc/openhop_repeater/config.yaml
sudo systemctl restart openhop-repeater
```

OpenHop Repeater itself is not removed.

## Legacy Notes

Older installs used `/opt/pymc_console`, `/etc/pymc_repeater/config.yaml`, and `pymc-repeater.service`. `manage.sh` detects those for compatibility, but new installs should use the OpenHop paths and `openhop-repeater.service`.
