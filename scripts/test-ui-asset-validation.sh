#!/usr/bin/env bash
# Smoke tests for the OpenHop UI asset validator.

set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
validator="$repo_dir/scripts/validate-ui-assets.sh"
tmp_dir="$(mktemp -d /tmp/openhop-ui-validation-test.XXXXXX)"

cleanup() {
    rm -rf "$tmp_dir"
}
trap cleanup EXIT

mkdir -p "$tmp_dir/valid"
cat > "$tmp_dir/valid/index.html" <<'HTML'
<!doctype html>
<title>OpenHop Console</title>
<script>window.OPENHOP_CONSOLE = true;</script>
HTML
bash "$validator" "$tmp_dir/valid" "valid fixture" >/dev/null

mkdir -p "$tmp_dir/compat"
cat > "$tmp_dir/compat/index.html" <<'HTML'
<!doctype html>
<script>
localStorage.getItem("pymc_jwt_token");
fetch("/api/check_pymc_console");
const radioTypes = ["pymc_usb", "pymc_tcp"];
</script>
HTML
bash "$validator" "$tmp_dir/compat" "compat fixture" >/dev/null

mkdir -p "$tmp_dir/invalid"
cat > "$tmp_dir/invalid/index.html" <<'HTML'
<!doctype html>
<title>pyMC Console</title>
HTML
if bash "$validator" "$tmp_dir/invalid" "invalid fixture" >/dev/null 2>&1; then
    echo "ERROR: stale pyMC fixture unexpectedly passed validation." >&2
    exit 1
fi

echo "OK: UI asset validation smoke tests passed."
