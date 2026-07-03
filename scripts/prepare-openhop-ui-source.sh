#!/usr/bin/env bash
# Normalize a checked-out UI source tree so its build output is OpenHop-branded.

set -euo pipefail

source_dir="${1:-}"
out_dir="${2:-dist}"
export OPENHOP_UI_OUT_DIR="$out_dir"

if [[ -z "$source_dir" ]]; then
    echo "usage: $0 <source-dir> [out-dir]" >&2
    exit 2
fi

if [[ ! -d "$source_dir" ]]; then
    echo "ERROR: UI source directory not found: $source_dir" >&2
    exit 1
fi

if [[ ! -f "$source_dir/package.json" ]]; then
    echo "ERROR: UI source directory has no package.json: $source_dir" >&2
    exit 1
fi

text_file_expr=(
    -name '.env*' -o -name '*.cjs' -o -name '*.css' -o -name '*.html' -o -name '*.js' -o
    -name '*.json' -o -name '*.md' -o -name '*.mjs' -o -name '*.ts' -o
    -name '*.tsx' -o -name '*.vue' -o -name '*.yaml' -o -name '*.yml'
)

find "$source_dir" -type f \( "${text_file_expr[@]}" \) -print0 | while IFS= read -r -d '' file; do
    perl -0pi -e '
        s#\.\./pyMC_Repeater/repeater/web/html#dist#g;
        s#\.\./pymc_repeater/repeater/web/html#dist#g;
        s#outDir:\s*["\x27][^"\x27]*pyMC_Repeater[^"\x27]*["\x27]#"outDir: \x27$ENV{OPENHOP_UI_OUT_DIR}\x27"#ge;
        s#outDir:\s*["\x27][^"\x27]*pymc_repeater[^"\x27]*["\x27]#"outDir: \x27$ENV{OPENHOP_UI_OUT_DIR}\x27"#ge;

        s#https://github\.com/pymc-dev/OpenHop Repeater#https://github.com/openhop-dev/openhop_repeater#g;
        s#https://github\.com/(pyMC-dev|pymc-dev|rightup|Treehouse-00)/pyMC_Repeater/issues#https://github.com/openhop-dev/openhop_repeater/issues#g;
        s#https://github\.com/(pyMC-dev|pymc-dev|rightup|Treehouse-00)/pyMC_Repeater#https://github.com/openhop-dev/openhop_repeater#g;
        s#https://github\.com/(pyMC-dev|pymc-dev|rightup|Treehouse-00)/pymc_repeater#https://github.com/openhop-dev/openhop_repeater#g;
        s#https://github\.com/(dmduran12|Treehouse-00)/pymc_console-dist#https://github.com/matthew73210/pymc_console-dist#g;
        s#https://github\.com/matthew73210/pymc_console-dist#https://github.com/openhop-dev/openhop_repeater#g;
        s#https://pymc\.dev#https://docs.openhop.dev#g;

        s#/opt/pymc_console/web/html#/opt/openhop_console/web/html#g;
        s#/opt/pymc_repeater#/opt/openhop_repeater#g;
        s#/etc/pymc_repeater#/etc/openhop_repeater#g;
        s#/var/lib/pymc_repeater#/var/lib/openhop_repeater#g;
        s#/var/log/pymc_repeater#/var/log/openhop_repeater#g;

        s#pymc-repeater\.service#openhop-repeater.service#g;
        s#pymc-repeater#openhop-repeater#g;
        s#pymc-identity#openhop-identity#g;
        s#pymc-#openhop-#g;
        s#pymc_repeater service#openhop-repeater service#g;
        s#pymc_repeater#openhop_repeater#g;
        s#pymc_console#openhop_console#g;
        s#check_openhop_console#check_pymc_console#g;
        s#pymcConsoleExists#openhopConsoleExists#g;
        s#selectPymcConsole#selectOpenhopConsole#g;
        s#pymcConsole#openhopConsole#g;
        s#PymcConsole#OpenhopConsole#g;
        s#pymcUsb#openhopUsb#g;
        s#pymcTcp#openhopTcp#g;
        s#pymcUSB#openhopUSB#g;
        s#pymcTCP#openhopTCP#g;
        s#PymcUsb#OpenhopUsb#g;
        s#PymcTcp#OpenhopTcp#g;

        s#Built-in pyMC Repeater web interface#Built-in OpenHop Repeater web interface#g;
        s#Built-in PyMC Repeater web interface#Built-in OpenHop Repeater web interface#g;
        s#pyMC_Repeater#OpenHop Repeater#g;
        s#pyMC Repeater#OpenHop Repeater#g;
        s#pyMc Repeater#OpenHop Repeater#g;
        s#pyMc repeater#OpenHop repeater#g;
        s#pyMC Console#OpenHop Console#g;
        s#PyMC Console#OpenHop Console#g;
        s#pyMC updater#OpenHop updater#g;
        s#pyMC Website#OpenHop Website#g;
        s#pyMC Docs#OpenHop Docs#g;
        s#pyMC#OpenHop#g;
        s#PYMC#OPENHOP#g;
        s#PyMC#OpenHop#g;
    ' "$file"
done

find "$source_dir" -depth \( -name '*pyMC*' -o -name '*PYMC*' -o -name '*pymc-repeater*' -o -name '*pymc_repeater*' \) -print0 |
while IFS= read -r -d '' path; do
    dir="$(dirname "$path")"
    base="$(basename "$path")"
    new_base="$base"
    new_base="${new_base//pyMC/OpenHop}"
    new_base="${new_base//PYMC/OPENHOP}"
    new_base="${new_base//pymc-repeater/openhop-repeater}"
    new_base="${new_base//pymc_repeater/openhop_repeater}"
    if [[ "$base" != "$new_base" ]]; then
        mv "$path" "$dir/$new_base"
    fi
done

echo "Prepared UI source for OpenHop branding: $source_dir"
