#!/bin/bash
# OpenHop Console - Dashboard Manager
#
# Scope: console-only wrapper.
#
# This script installs, updates, and removes the prebuilt Console dashboard. It
# does not install or manage OpenHop Repeater itself; service lifecycle, radio
# setup, GPIO, and serial device setup belong to upstream OpenHop Repeater.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

OPENHOP_INSTALL_DIR="/opt/openhop_repeater"
OPENHOP_CONFIG_DIR="/etc/openhop_repeater"
OPENHOP_SERVICE_NAME="openhop-repeater"
OPENHOP_REPEATER_PACKAGE="openhop_repeater"

LEGACY_INSTALL_DIR="/opt/pymc_repeater"
LEGACY_CONFIG_DIR="/etc/pymc_repeater"
LEGACY_SERVICE_NAME="pymc-repeater"
LEGACY_REPEATER_PACKAGE="pymc-repeater"

REPEATER_USER="repeater"
REPEATER_GROUP="repeater"

CONSOLE_DIR="${OPENHOP_CONSOLE_DIR:-${PYMC_CONSOLE_DIR:-/opt/openhop_console}}"
LEGACY_CONSOLE_DIR="/opt/pymc_console"
UI_DIR="$CONSOLE_DIR/web/html"
LEGACY_UI_DIR="$LEGACY_CONSOLE_DIR/web/html"

UI_REPO="${OPENHOP_CONSOLE_REPO:-${PYMC_CONSOLE_REPO:-matthew73210/pymc_console-dist}}"
UI_RELEASE_URL="https://github.com/${UI_REPO}/releases"
UI_TARBALL="${OPENHOP_UI_TARBALL:-openhop-console-ui-latest.tar.gz}"
LEGACY_UI_TARBALL="${PYMC_UI_TARBALL:-pymc-ui-latest.tar.gz}"

export ASSUME_YES="${ASSUME_YES:-0}"

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
    RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
    CYAN='\033[0;36m'; BOLD='\033[1m'; DIM='\033[2m'; NC='\033[0m'
else
    RED=''; GREEN=''; YELLOW=''; CYAN=''; BOLD=''; DIM=''; NC=''
fi

print_step()    { echo -e "\n${BOLD}${CYAN}[$1/$2]${NC} ${BOLD}$3${NC}"; }
print_success() { echo -e "    ${GREEN}OK${NC} $1"; }
print_error()   { echo -e "    ${RED}ERROR${NC} ${RED}$1${NC}" >&2; }
print_info()    { echo -e "    ${CYAN}->${NC} $1"; }
print_warning() { echo -e "    ${YELLOW}WARN${NC} $1"; }

print_banner() {
    echo ""
    echo -e "${BOLD}${CYAN}OpenHop Console${NC}"
    echo -e "${DIM}React dashboard for OpenHop Repeater${NC}"
    echo ""
}

prompt_yes_no() {
    local question="$1"
    local default="${2:-n}"
    local prompt_suffix reply

    if [[ "$ASSUME_YES" == "1" ]]; then
        return 0
    fi

    if [[ "$default" == "y" ]]; then
        prompt_suffix="[Y/n]"
    else
        prompt_suffix="[y/N]"
    fi

    read -r -p "$(echo -e "    ${CYAN}?${NC} ${question} ${prompt_suffix} ")" reply
    reply="${reply:-$default}"
    case "$reply" in
        y|Y|yes|YES) return 0 ;;
        *)           return 1 ;;
    esac
}

pip_has_package() {
    local pkg="$1"
    command -v pip3 &>/dev/null && pip3 show "$pkg" &>/dev/null
}

pip_version() {
    local pkg="$1"
    command -v pip3 &>/dev/null || return 0
    pip3 show "$pkg" 2>/dev/null | awk '/^Version:/ {print $2; exit}'
}

systemd_unit_exists() {
    local service="$1"
    command -v systemctl &>/dev/null || return 1
    [[ -n "$(systemctl list-unit-files --no-legend --no-pager "${service}.service" 2>/dev/null)" ]]
}

openhop_repeater_installed() {
    pip_has_package "$OPENHOP_REPEATER_PACKAGE" \
        || pip_has_package "openhop-repeater" \
        || systemd_unit_exists "$OPENHOP_SERVICE_NAME" \
        || [[ -d "$OPENHOP_INSTALL_DIR" && -f "$OPENHOP_INSTALL_DIR/pyproject.toml" ]]
}

legacy_repeater_installed() {
    pip_has_package "$LEGACY_REPEATER_PACKAGE" \
        || pip_has_package "pymc_repeater" \
        || systemd_unit_exists "$LEGACY_SERVICE_NAME" \
        || [[ -d "$LEGACY_INSTALL_DIR" && -f "$LEGACY_INSTALL_DIR/pyproject.toml" ]]
}

repeater_installed() {
    openhop_repeater_installed || legacy_repeater_installed
}

active_config_dir() {
    if [[ -d "$OPENHOP_CONFIG_DIR" ]] || openhop_repeater_installed; then
        echo "$OPENHOP_CONFIG_DIR"
    else
        echo "$LEGACY_CONFIG_DIR"
    fi
}

active_config_file() {
    echo "$(active_config_dir)/config.yaml"
}

active_service_name() {
    if systemd_unit_exists "$OPENHOP_SERVICE_NAME" || openhop_repeater_installed; then
        echo "$OPENHOP_SERVICE_NAME"
    else
        echo "$LEGACY_SERVICE_NAME"
    fi
}

get_repeater_version() {
    local v
    v="$(pip_version "$OPENHOP_REPEATER_PACKAGE")"
    [[ -n "$v" ]] || v="$(pip_version "openhop-repeater")"
    [[ -n "$v" ]] || v="$(pip_version "$LEGACY_REPEATER_PACKAGE")"
    [[ -n "$v" ]] || v="$(pip_version "pymc_repeater")"
    echo "${v:-unknown}"
}

console_installed() {
    [[ -d "$UI_DIR" ]]
}

legacy_console_installed() {
    [[ -d "$LEGACY_UI_DIR" ]]
}

get_console_version() {
    local version_file="$UI_DIR/VERSION"
    [[ -f "$version_file" ]] || version_file="$LEGACY_UI_DIR/VERSION"
    if [[ -f "$version_file" ]]; then
        local v
        v=$(tr -d '[:space:]' < "$version_file")
        echo "${v:-unknown}"
    else
        echo "unknown"
    fi
}

service_is_active() {
    local service
    service="$(active_service_name)"
    command -v systemctl &>/dev/null && systemctl is-active "$service" &>/dev/null
}

service_is_enabled() {
    local service
    service="$(active_service_name)"
    command -v systemctl &>/dev/null && systemctl is-enabled "$service" &>/dev/null
}

require_root() {
    if [[ "$EUID" -ne 0 ]]; then
        print_error "This command requires root. Run: sudo $0 $1"
        return 1
    fi
}

print_compat_warnings() {
    if [[ -n "${PYMC_CONSOLE_DIR:-}" && -z "${OPENHOP_CONSOLE_DIR:-}" ]]; then
        print_warning "PYMC_CONSOLE_DIR is deprecated; use OPENHOP_CONSOLE_DIR."
    fi
    if [[ -n "${PYMC_CONSOLE_REPO:-}" && -z "${OPENHOP_CONSOLE_REPO:-}" ]]; then
        print_warning "PYMC_CONSOLE_REPO is deprecated; use OPENHOP_CONSOLE_REPO."
    fi
    if [[ -n "${PYMC_UI_TARBALL:-}" && -z "${OPENHOP_UI_TARBALL:-}" ]]; then
        print_warning "PYMC_UI_TARBALL is deprecated; use OPENHOP_UI_TARBALL."
    fi
    if legacy_repeater_installed && ! openhop_repeater_installed; then
        print_warning "Legacy pyMC Repeater detected. Install/upgrade to OpenHop Repeater when possible."
    fi
}

preflight_check() {
    local config_file service unit_state="not found"
    local repeater_ok=false config_ok=false yq_ok=false

    config_file="$(active_config_file)"
    service="$(active_service_name)"

    repeater_installed && repeater_ok=true
    [[ -f "$config_file" ]] && config_ok=true
    command -v yq &>/dev/null && yq_ok=true

    if systemd_unit_exists "$service"; then
        local enabled="disabled"
        local active="inactive"
        service_is_enabled && enabled="enabled"
        service_is_active && active="active"
        unit_state="${service}.service ${enabled}, ${active}"
    fi

    echo -e "  ${DIM}Preflight:${NC}"
    if [[ "$repeater_ok" == true ]]; then
        echo -e "    OpenHop Repeater: ${GREEN}found${NC} (v$(get_repeater_version))"
    else
        echo -e "    OpenHop Repeater: ${RED}not found${NC}"
    fi
    if [[ "$config_ok" == true ]]; then
        echo -e "    Config file:      ${GREEN}present${NC} ($config_file)"
    else
        echo -e "    Config file:      ${YELLOW}missing${NC} ($config_file)"
    fi
    if [[ "$yq_ok" == true ]]; then
        echo -e "    yq:               ${GREEN}present${NC}"
    else
        echo -e "    yq:               ${YELLOW}missing${NC} (web_path patch will be skipped)"
    fi
    echo -e "    Service unit:     ${unit_state}"
    echo ""

    [[ "$repeater_ok" == true ]]
}

print_repeater_missing_help() {
    print_error "OpenHop Repeater is not installed."
    echo ""
    echo "    The Console dashboard is served by OpenHop Repeater and needs it first."
    echo "    Install upstream OpenHop Repeater:"
    echo ""
    echo -e "      ${CYAN}git clone https://github.com/openhop-dev/openhop_repeater.git${NC}"
    echo -e "      ${CYAN}cd openhop_repeater && sudo ./manage.sh install${NC}"
    echo ""
}

print_service_hint() {
    local service
    service="$(active_service_name)"
    if ! systemd_unit_exists "$service"; then
        print_warning "${service}.service is not registered with systemd."
        echo "    Install or repair OpenHop Repeater to register the service."
        return
    fi
    if service_is_active; then
        print_success "${service}.service is active."
    else
        print_warning "${service}.service is not running."
        echo -e "    Start it: ${CYAN}sudo systemctl start ${service}${NC}"
    fi
    if ! service_is_enabled; then
        echo -e "    Enable on boot: ${CYAN}sudo systemctl enable ${service}${NC}"
    fi
}

migrate_legacy_console_dir() {
    if [[ "$CONSOLE_DIR" == "$LEGACY_CONSOLE_DIR" ]]; then
        return 0
    fi
    if [[ -d "$LEGACY_CONSOLE_DIR" && ! -e "$CONSOLE_DIR" ]]; then
        print_info "Migrating legacy Console directory to $CONSOLE_DIR"
        mkdir -p "$(dirname "$CONSOLE_DIR")"
        mv "$LEGACY_CONSOLE_DIR" "$CONSOLE_DIR"
        chown -R "$REPEATER_USER:$REPEATER_GROUP" "$CONSOLE_DIR" 2>/dev/null || true
        print_success "Migrated $LEGACY_CONSOLE_DIR to $CONSOLE_DIR"
    elif [[ -d "$LEGACY_CONSOLE_DIR" && -d "$CONSOLE_DIR" ]]; then
        print_warning "Legacy Console directory still exists at $LEGACY_CONSOLE_DIR; leaving it untouched."
    fi
}

patch_web_path() {
    local config_file="$1"
    local is_fresh_install="$2"

    if [[ ! -f "$config_file" ]] || ! command -v yq &>/dev/null; then
        print_warning "Could not configure web_path automatically."
        if [[ ! -f "$config_file" ]]; then
            echo -e "    Reason: ${YELLOW}$config_file not found${NC}."
        else
            echo -e "    Reason: ${YELLOW}yq is not installed${NC}."
        fi
        echo -e "    Set it manually with:"
        echo -e "      ${CYAN}sudo yq -i '.web.web_path = \"$UI_DIR\"' $config_file${NC}"
        echo -e "    Then restart OpenHop Repeater:"
        echo -e "      ${CYAN}sudo systemctl restart $(active_service_name)${NC}"
        return 0
    fi

    yq -i '.web //= {}' "$config_file" 2>/dev/null || true

    if [[ "$is_fresh_install" == true ]]; then
        yq -i ".web.web_path = \"$UI_DIR\"" "$config_file"
        print_success "Dashboard installed (web_path configured)"
        return 0
    fi

    local configured_path
    configured_path="$(yq '.web.web_path // ""' "$config_file" 2>/dev/null | tr -d '"')"
    if [[ -z "$configured_path" || "$configured_path" == "null" ]]; then
        yq -i ".web.web_path = \"$UI_DIR\"" "$config_file"
        print_success "Dashboard updated (web_path configured)"
    elif [[ "$configured_path" == "$LEGACY_UI_DIR" ]]; then
        yq -i ".web.web_path = \"$UI_DIR\"" "$config_file"
        print_success "Dashboard updated (legacy web_path migrated)"
    else
        print_success "Dashboard updated (web_path preserved)"
    fi
}

download_release_tarball() {
    local temp_file="$1"
    local primary_url="${UI_RELEASE_URL}/latest/download/${UI_TARBALL}"
    local legacy_url="${UI_RELEASE_URL}/latest/download/${LEGACY_UI_TARBALL}"

    if curl -fsSL -o "$temp_file" "$primary_url"; then
        return 0
    fi

    if [[ "$UI_TARBALL" != "$LEGACY_UI_TARBALL" ]]; then
        print_warning "OpenHop-named release asset not found; trying legacy asset name."
        if curl -fsSL -o "$temp_file" "$legacy_url"; then
            return 0
        fi
    fi

    print_error "Download failed from $primary_url"
    if [[ "$UI_TARBALL" != "$LEGACY_UI_TARBALL" ]]; then
        print_error "Fallback also failed from $legacy_url"
    fi
    return 1
}

install_dashboard() {
    local config_file temp_file is_fresh_install=true
    config_file="$(active_config_file)"
    temp_file="/tmp/openhop-console-ui-$$.tar.gz"

    console_installed && is_fresh_install=false
    legacy_console_installed && is_fresh_install=false

    migrate_legacy_console_dir

    print_info "Downloading dashboard..."
    if ! download_release_tarball "$temp_file"; then
        rm -f "$temp_file"
        return 1
    fi

    rm -rf "$UI_DIR"
    mkdir -p "$UI_DIR"
    tar -xzf "$temp_file" -C "$UI_DIR"
    rm -f "$temp_file"

    chown -R "$REPEATER_USER:$REPEATER_GROUP" "$CONSOLE_DIR" 2>/dev/null || true
    patch_web_path "$config_file" "$is_fresh_install"

    local size
    size=$(du -sh "$UI_DIR" 2>/dev/null | cut -f1)
    print_info "Size: $size"
}

do_install() {
    require_root "install" || return 1

    print_banner
    print_compat_warnings
    echo -e "  ${DIM}Mode: Install Console${NC}"
    echo ""
    if ! preflight_check; then
        print_repeater_missing_help
        return 1
    fi

    if console_installed || legacy_console_installed; then
        if ! prompt_yes_no "Console dashboard already installed; reinstall?" "n"; then
            print_info "Install cancelled."
            return 0
        fi
    fi

    print_step 1 1 "Installing dashboard"
    install_dashboard

    local ip
    ip=$(hostname -I 2>/dev/null | awk '{print $1}')
    echo ""
    echo -e "${GREEN}${BOLD}Console Installed${NC}"
    echo ""
    echo -e "    OpenHop Console: ${CYAN}v$(get_console_version)${NC}"
    echo -e "    Install path:     ${CYAN}$UI_DIR${NC}"
    echo ""
    echo -e "  Dashboard: ${CYAN}http://${ip:-localhost}:8000/${NC}"
    echo ""
    print_service_hint
    echo ""
}

do_upgrade() {
    require_root "upgrade" || return 1

    print_banner
    print_compat_warnings
    echo -e "  ${DIM}Mode: Upgrade Console${NC}"
    echo ""
    if ! preflight_check; then
        print_repeater_missing_help
        return 1
    fi

    if ! console_installed && ! legacy_console_installed; then
        print_error "Console is not installed. Run: sudo $0 install"
        return 1
    fi

    if [[ -d "$SCRIPT_DIR/.git" ]]; then
        print_info "Checking for Console wrapper updates..."
        git config --global --add safe.directory "$SCRIPT_DIR" 2>/dev/null || true

        local local_hash remote_hash
        local_hash=$(git -C "$SCRIPT_DIR" rev-parse HEAD 2>/dev/null || echo "")
        git -C "$SCRIPT_DIR" fetch origin 2>/dev/null || true
        remote_hash=$(git -C "$SCRIPT_DIR" rev-parse origin/main 2>/dev/null || echo "")

        if [[ -n "$remote_hash" && "$local_hash" != "$remote_hash" ]]; then
            if git -C "$SCRIPT_DIR" pull --ff-only 2>/dev/null; then
                print_success "Console wrapper updated; restarting..."
                exec "$SCRIPT_DIR/manage.sh" upgrade
            else
                print_warning "Wrapper update skipped because the checkout cannot fast-forward cleanly."
            fi
        fi
    fi

    local ui_before ui_after
    ui_before=$(get_console_version)

    print_step 1 1 "Updating dashboard"
    install_dashboard

    ui_after=$(get_console_version)

    local ip
    ip=$(hostname -I 2>/dev/null | awk '{print $1}')
    echo ""
    echo -e "${GREEN}${BOLD}Upgrade Complete${NC}"
    echo ""
    if [[ "$ui_before" != "$ui_after" ]]; then
        echo -e "    OpenHop Console: ${DIM}v$ui_before${NC} -> ${CYAN}v$ui_after${NC}"
    else
        echo -e "    OpenHop Console: ${CYAN}v$ui_after${NC}"
    fi
    echo ""
    echo -e "  Dashboard: ${CYAN}http://${ip:-localhost}:8000/${NC}"
    echo ""
    print_service_hint
    echo ""
}

do_uninstall() {
    require_root "uninstall" || return 1

    local has_console=false has_legacy_console=false has_repeater=false
    console_installed && has_console=true
    legacy_console_installed && has_legacy_console=true
    repeater_installed && has_repeater=true

    print_banner
    echo -e "  ${DIM}Detected:${NC}"
    if [[ "$has_repeater" == true ]]; then
        echo -e "    Repeater:       ${DIM}present (v$(get_repeater_version)); will NOT be touched${NC}"
    else
        echo -e "    Repeater:       ${DIM}not found${NC}"
    fi
    echo -e "    Console:        $([[ "$has_console" == true ]] && echo "${GREEN}found${NC} ($CONSOLE_DIR)" || echo "${DIM}not found${NC}")"
    echo -e "    Legacy Console: $([[ "$has_legacy_console" == true ]] && echo "${YELLOW}found${NC} ($LEGACY_CONSOLE_DIR)" || echo "${DIM}not found${NC}")"
    echo -e "    This repo:      ${GREEN}$SCRIPT_DIR${NC}"
    echo ""

    if [[ "$has_console" == false && "$has_legacy_console" == false ]]; then
        print_info "Console is not installed; no dashboard directory to remove."
    fi

    echo "  Will remove:"
    [[ "$has_console" == true ]] && echo "    - Console dashboard ($CONSOLE_DIR)"
    [[ "$has_legacy_console" == true ]] && echo "    - Legacy Console dashboard ($LEGACY_CONSOLE_DIR)"
    echo "    - this Console wrapper repo ($SCRIPT_DIR)"
    echo ""

    if ! prompt_yes_no "Continue with uninstall?" "n"; then
        print_info "Uninstall cancelled."
        return 0
    fi

    local step=1 total=1
    [[ "$has_console" == true ]] && ((total++))
    [[ "$has_legacy_console" == true ]] && ((total++))

    if [[ "$has_console" == true ]]; then
        print_step $step $total "Removing Console dashboard"
        rm -rf "$CONSOLE_DIR"
        print_success "Removed $CONSOLE_DIR"
        ((step++))
    fi

    if [[ "$has_legacy_console" == true ]]; then
        print_step $step $total "Removing legacy Console dashboard"
        rm -rf "$LEGACY_CONSOLE_DIR"
        print_success "Removed $LEGACY_CONSOLE_DIR"
        ((step++))
    fi

    print_step $step $total "Scheduling wrapper repo removal"
    if [[ -z "$SCRIPT_DIR" || "$SCRIPT_DIR" == "/" ]]; then
        print_warning "Refusing to self-delete: SCRIPT_DIR is unsafe ($SCRIPT_DIR)"
    elif [[ "$(basename "$SCRIPT_DIR")" != *pymc_console* && "$(basename "$SCRIPT_DIR")" != *openhop_console* ]]; then
        print_warning "Refusing to self-delete: $SCRIPT_DIR does not look like a Console checkout"
    else
        echo -e "    ${YELLOW}Will remove $SCRIPT_DIR after script exits${NC}"
        trap "rm -rf '$SCRIPT_DIR'" EXIT
        print_success "Scheduled for removal"
    fi

    echo ""
    echo -e "${GREEN}${BOLD}Uninstall Complete${NC}"
    echo ""
}

show_help() {
    cat << EOF
OpenHop Console - Dashboard Manager

Usage: $0 [--yes] <command>

Commands:
  install        Install the Console dashboard (requires OpenHop Repeater)
  upgrade        Refresh Console dashboard assets (preserves web_path)
  uninstall      Remove Console dashboard and this repo
  -h, --help     Show this help

Flags:
  --yes, -y      Auto-confirm all prompts (also: ASSUME_YES=1)

Environment:
  OPENHOP_CONSOLE_DIR    Install directory (default: /opt/openhop_console)
  OPENHOP_CONSOLE_REPO   GitHub repo for release assets (default: $UI_REPO)
  OPENHOP_UI_TARBALL     Preferred release asset (default: $UI_TARBALL)

Notes:
  - This script manages the Console dashboard only.
  - OpenHop Repeater install, upgrade, uninstall, service control, logs,
    radio setup, GPIO, and serial devices are handled by upstream:
      https://github.com/openhop-dev/openhop_repeater
  - Legacy PYMC_* environment variables are accepted for compatibility.
EOF
}

print_deprecated_subcommand() {
    local cmd="$1"
    local arg="$2"
    print_error "\`$cmd $arg\` has been deprecated."
    echo "    The Full Stack / Console-only distinction no longer exists."
    echo "    This script now manages the Console dashboard only."
    echo "    To install or manage OpenHop Repeater, use upstream's manage.sh."
    echo ""
    show_help
}

_args=()
for arg in "$@"; do
    case "$arg" in
        --yes|-y)    ASSUME_YES=1 ;;
        --no-color)  ;;
        *)           _args+=("$arg") ;;
    esac
done
set -- "${_args[@]}"
unset _args

case "${1:-}" in
    -h|--help|"")
        show_help
        ;;
    install)
        case "${2:-}" in
            full|console)
                print_deprecated_subcommand "install" "$2"
                exit 1
                ;;
            "")
                do_install
                ;;
            *)
                print_error "Unknown argument: install $2"
                show_help
                exit 1
                ;;
        esac
        ;;
    upgrade)
        case "${2:-}" in
            full|console)
                print_deprecated_subcommand "upgrade" "$2"
                exit 1
                ;;
            "")
                do_upgrade
                ;;
            *)
                print_error "Unknown argument: upgrade $2"
                show_help
                exit 1
                ;;
        esac
        ;;
    uninstall)
        do_uninstall
        ;;
    start|stop|restart|status|logs)
        service="$(active_service_name)"
        print_error "\`$1\` is not managed by OpenHop Console."
        echo "    Service control, status, and logs belong to OpenHop Repeater."
        echo "    Use upstream's manage.sh, or run systemctl/journalctl directly:"
        echo ""
        if [[ "$1" == "logs" ]]; then
            echo -e "      ${CYAN}sudo journalctl -u ${service} -f${NC}"
        else
            echo -e "      ${CYAN}sudo systemctl $1 ${service}${NC}"
        fi
        echo ""
        exit 1
        ;;
    *)
        print_error "Unknown command: $1"
        show_help
        exit 1
        ;;
esac
