#!/usr/bin/env bash
# Validate OpenHop Console static assets before publishing or installing them.

set -euo pipefail

asset_dir="${1:-}"
label="${2:-OpenHop Console assets}"

if [[ -z "$asset_dir" ]]; then
    echo "usage: $0 <asset-dir> [label]" >&2
    exit 2
fi

if [[ ! -d "$asset_dir" ]]; then
    echo "ERROR: $label directory not found: $asset_dir" >&2
    exit 1
fi

if [[ ! -f "$asset_dir/index.html" ]]; then
    echo "ERROR: $label must contain index.html at the archive root." >&2
    exit 1
fi

stale_pattern='pyMC|PYMC|pymc|pymc_console|pymc-repeater|/opt/pymc|/etc/pymc'

# Explicit compatibility exceptions. Keep this small and tied to backend APIs or
# existing browser-storage migrations; browser-visible pyMC branding is invalid.
allowlist_pattern='(/api/check_pymc_console|check_pymc_console|pymc-color-scheme|pymc-background|pymc_jwt_token|pymc_client_id|pymc_pref_|pymc_config_cache|pymc_core|pymc_usb|pymc_tcp|pymc-do-upgrade|pymc_build_deps)'

content_hits_all="$(
    grep -RInE "$stale_pattern" "$asset_dir" \
        --exclude-dir=.git \
        --binary-files=without-match 2>/dev/null \
        | grep -Ev "$allowlist_pattern" || true
)"

path_hits_all="$(
    cd "$asset_dir" && find . -print \
        | grep -Ei "$stale_pattern" \
        | grep -Ev "$allowlist_pattern" || true
)"

truncate_hits() {
    awk '
        NR <= 80 {
            if (length($0) > 240) {
                print substr($0, 1, 240) "..."
            } else {
                print
            }
        }
    '
}

content_hits="$(printf '%s\n' "$content_hits_all" | truncate_hits)"
path_hits="$(printf '%s\n' "$path_hits_all" | truncate_hits)"

if [[ -n "$content_hits_all" || -n "$path_hits_all" ]]; then
    echo "ERROR: $label contains stale pyMC references." >&2
    echo "" >&2
    if [[ -n "$content_hits" ]]; then
        echo "Non-allowlisted content hits:" >&2
        echo "$content_hits" >&2
        content_count="$(printf '%s\n' "$content_hits_all" | sed '/^$/d' | wc -l | tr -d ' ')"
        if [[ "$content_count" -gt 80 ]]; then
            echo "... ${content_count} total non-allowlisted content hits." >&2
        fi
        echo "" >&2
    fi
    if [[ -n "$path_hits" ]]; then
        echo "Non-allowlisted path hits:" >&2
        echo "$path_hits" >&2
        path_count="$(printf '%s\n' "$path_hits_all" | sed '/^$/d' | wc -l | tr -d ' ')"
        if [[ "$path_count" -gt 80 ]]; then
            echo "... ${path_count} total non-allowlisted path hits." >&2
        fi
        echo "" >&2
    fi
    echo "Allowed compatibility identifiers are limited to:" >&2
    echo "  check_pymc_console API endpoint, legacy browser storage keys," >&2
    echo "  upstream pymc_core internals, pymc_usb/pymc_tcp radio types," >&2
    echo "  and updater/wheel compatibility names." >&2
    exit 1
fi

echo "OK: $label passed OpenHop asset validation."
