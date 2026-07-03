# OpenHop Console Release Notes

This repository is the distribution wrapper for the prebuilt OpenHop Console dashboard.

## Artifact Names

Preferred release assets:

```text
openhop-console-ui-latest.tar.gz
openhop-console-ui-v<version>.tar.gz
openhop-console-ui-v<version>.zip
```

Compatibility asset names from the pre-OpenHop wrapper may still exist on older releases:

```text
pymc-ui-latest.tar.gz
pymc-ui-v<version>.tar.gz
pymc-ui-v<version>.zip
```

`manage.sh` tries the OpenHop asset first and then falls back to `pymc-ui-latest.tar.gz` so existing releases remain installable.

## Version Bump

```bash
cd frontend
npm version patch
git push origin main
git push origin --tags
```

Use `minor` for new user-facing features and `major` for breaking changes.

## Local Validation

This distribution repo normally contains prebuilt `frontend/dist` assets. Before publishing a release, verify:

```bash
bash -n ../manage.sh
npm run build
```

Then confirm:

```bash
test -f frontend/dist/index.html
test "$(cat frontend/dist/VERSION)" = "$(node -p "require('./package.json').version")"
```

## Install Verification

On a clean Debian LXC or Debian host:

```bash
apt update
apt install -y git ca-certificates
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

## Migration Checks

For a legacy install, verify the wrapper migrates only wrapper-owned paths:

```bash
test ! -d /opt/pymc_console || ./manage.sh --yes upgrade
grep -R '/opt/pymc_console' /etc/openhop_repeater/config.yaml /etc/pymc_repeater/config.yaml 2>/dev/null || true
grep -R '/opt/openhop_console/web/html' /etc/openhop_repeater/config.yaml
```

Do not rename upstream `pymc_core` references unless upstream publishes a corresponding `openhop_core` Python package/import. As of the current upstream metadata inspected for this change, the `openhop_core` repository still declares the Python project as `pymc_core`.
