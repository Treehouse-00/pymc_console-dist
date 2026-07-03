#!/bin/bash
# OpenHop Console - Dashboard Manager
#
# Scope: full wrapper installer.
#
# This script bootstraps OpenHop Repeater and installs the prebuilt Console
# dashboard. It keeps protocol/radio logic in upstream OpenHop packages.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ORIGINAL_ARGS=("$@")

OPENHOP_INSTALL_DIR="/opt/openhop_repeater"
OPENHOP_SOURCE_DIR="${OPENHOP_REPEATER_SOURCE_DIR:-$OPENHOP_INSTALL_DIR/source}"
OPENHOP_CONFIG_DIR="/etc/openhop_repeater"
OPENHOP_LOG_DIR="/var/log/openhop_repeater"
OPENHOP_DATA_DIR="/var/lib/openhop_repeater"
OPENHOP_VENV_DIR="$OPENHOP_INSTALL_DIR/venv"
OPENHOP_VENV_PYTHON="$OPENHOP_VENV_DIR/bin/python"
OPENHOP_SERVICE_NAME="openhop-repeater"
OPENHOP_REPEATER_PACKAGE="openhop_repeater"
OPENHOP_REPEATER_REPO="${OPENHOP_REPEATER_REPO:-https://github.com/openhop-dev/openhop_repeater.git}"
OPENHOP_REPEATER_REF="${OPENHOP_REPEATER_REF:-main}"

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
    if [[ -x "$OPENHOP_VENV_PYTHON" ]]; then
        "$OPENHOP_VENV_PYTHON" -c "from importlib.metadata import version; print(version('$pkg'))" 2>/dev/null && return 0
    fi
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
        if command -v sudo &>/dev/null; then
            print_info "Root privileges required; re-running with sudo."
            exec sudo -E bash "$SCRIPT_DIR/manage.sh" "${ORIGINAL_ARGS[@]}"
        fi
        print_error "This command requires root. Run as root, or install sudo and retry: sudo $0 $1"
        exit 1
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
    print_error "OpenHop Repeater is not installed and automatic bootstrap failed."
    echo ""
    echo "    Check package manager, network, and systemd availability, then retry:"
    echo -e "      ${CYAN}$0 install${NC}"
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

install_system_packages() {
    if ! command -v apt-get &>/dev/null; then
        print_error "Automatic package installation currently supports Debian/Ubuntu systems with apt-get."
        return 1
    fi

    print_info "Installing system packages for OpenHop Repeater and Console..."
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        git curl wget ca-certificates \
        python3 python3-venv python3-pip python3-dev build-essential \
        libffi-dev libusb-1.0-0 swig jq sudo iproute2 i2c-tools \
        python3-rrdtool whiptail

    DEBIAN_FRONTEND=noninteractive apt-get install -y policykit-1 2>/dev/null \
        || DEBIAN_FRONTEND=noninteractive apt-get install -y polkitd pkexec 2>/dev/null \
        || print_warning "Could not install polkit; sudoers fallback will still be configured."
}

ensure_mikefarah_yq() {
    if command -v yq &>/dev/null && yq --version 2>&1 | grep -q "mikefarah/yq"; then
        return 0
    fi

    print_info "Installing mikefarah yq for YAML config edits..."
    local yq_version="v4.40.5"
    local yq_binary="yq_linux_arm64"
    case "$(uname -m)" in
        x86_64) yq_binary="yq_linux_amd64" ;;
        armv7*|armv7l) yq_binary="yq_linux_arm" ;;
        aarch64|arm64) yq_binary="yq_linux_arm64" ;;
    esac
    curl -fsSL -o /usr/local/bin/yq \
        "https://github.com/mikefarah/yq/releases/download/${yq_version}/${yq_binary}"
    chmod +x /usr/local/bin/yq
}

fetch_openhop_repeater_source() {
    print_info "Fetching OpenHop Repeater source from $OPENHOP_REPEATER_REPO"
    mkdir -p "$(dirname "$OPENHOP_SOURCE_DIR")"

    if [[ -d "$OPENHOP_SOURCE_DIR/.git" ]]; then
        git -C "$OPENHOP_SOURCE_DIR" fetch origin
        git -C "$OPENHOP_SOURCE_DIR" checkout "$OPENHOP_REPEATER_REF"
        git -C "$OPENHOP_SOURCE_DIR" pull --ff-only origin "$OPENHOP_REPEATER_REF"
    elif [[ -e "$OPENHOP_SOURCE_DIR" && -n "$(ls -A "$OPENHOP_SOURCE_DIR" 2>/dev/null)" ]]; then
        print_error "$OPENHOP_SOURCE_DIR exists but is not a git checkout."
        echo "    Move it aside or set OPENHOP_REPEATER_SOURCE_DIR to another path."
        return 1
    else
        git clone --depth 1 --branch "$OPENHOP_REPEATER_REF" "$OPENHOP_REPEATER_REPO" "$OPENHOP_SOURCE_DIR"
    fi

    if [[ ! -f "$OPENHOP_SOURCE_DIR/manage.sh" ]]; then
        print_error "Upstream OpenHop Repeater checkout does not contain manage.sh."
        return 1
    fi
    if [[ ! -f "$OPENHOP_SOURCE_DIR/pyproject.toml" || ! -f "$OPENHOP_SOURCE_DIR/openhop-repeater.service" ]]; then
        print_error "OpenHop Repeater checkout is missing expected packaging or systemd files."
        return 1
    fi
}

migrate_legacy_repeater_paths() {
    local timestamp
    timestamp="$(date +%Y%m%d_%H%M%S)"

    migrate_one() {
        local legacy="$1"
        local current="$2"
        local label="$3"
        local backup_path

        [[ -e "$legacy" ]] || return 0
        mkdir -p "$current" 2>/dev/null || true

        if [[ ! -e "$current" || -z "$(ls -A "$current" 2>/dev/null)" ]]; then
            rm -rf "$current" 2>/dev/null || true
            mv "$legacy" "$current"
            print_success "Migrated legacy $label path: $legacy -> $current"
            return 0
        fi

        cp -an "$legacy"/. "$current"/ 2>/dev/null || true
        backup_path="${legacy}.migrated.${timestamp}"
        mv "$legacy" "$backup_path"
        print_success "Merged legacy $label data into $current; archived $backup_path"
    }

    migrate_one "$LEGACY_CONFIG_DIR" "$OPENHOP_CONFIG_DIR" "config"
    migrate_one "/var/log/pymc_repeater" "$OPENHOP_LOG_DIR" "log"
    migrate_one "/var/lib/pymc_repeater" "$OPENHOP_DATA_DIR" "data"
}

ensure_repeater_user_and_dirs() {
    if ! getent group "$REPEATER_GROUP" >/dev/null 2>&1; then
        groupadd --system "$REPEATER_GROUP"
    fi

    if ! id "$REPEATER_USER" &>/dev/null; then
        useradd --system --gid "$REPEATER_GROUP" --home "$OPENHOP_DATA_DIR" --shell /sbin/nologin "$REPEATER_USER"
    else
        usermod -d "$OPENHOP_DATA_DIR" "$REPEATER_USER" 2>/dev/null || true
        usermod -g "$REPEATER_GROUP" "$REPEATER_USER" 2>/dev/null || true
    fi

    mkdir -p "$OPENHOP_INSTALL_DIR" "$OPENHOP_CONFIG_DIR" "$OPENHOP_LOG_DIR" "$OPENHOP_DATA_DIR"
    mkdir -p "$OPENHOP_DATA_DIR/.config/openhop_repeater"

    for grp in plugdev dialout gpio i2c spi; do
        getent group "$grp" >/dev/null 2>&1 && usermod -a -G "$grp" "$REPEATER_USER" 2>/dev/null || true
    done

    chown -R "$REPEATER_USER:$REPEATER_GROUP" "$OPENHOP_CONFIG_DIR" "$OPENHOP_LOG_DIR" "$OPENHOP_DATA_DIR" 2>/dev/null || true
    chmod 750 "$OPENHOP_CONFIG_DIR" "$OPENHOP_LOG_DIR" 2>/dev/null || true
    chmod 755 "$OPENHOP_INSTALL_DIR" "$OPENHOP_DATA_DIR" 2>/dev/null || true
}

ensure_openhop_config() {
    local example="$OPENHOP_SOURCE_DIR/config.yaml.example"
    local config_file="$OPENHOP_CONFIG_DIR/config.yaml"

    if [[ ! -f "$example" ]]; then
        print_error "Missing upstream config example: $example"
        return 1
    fi

    cp "$example" "$OPENHOP_CONFIG_DIR/config.yaml.example"
    if [[ ! -f "$config_file" ]]; then
        cp "$example" "$config_file"
        # OpenHop treats null/none radio_type as no-radio mode, which lets a fresh
        # Debian LXC start the web UI before serial/SPI hardware is passed through.
        yq -i '.radio_type = null' "$config_file"
    fi

    UI_DIR="$UI_DIR" yq -i '(.web //= {}) | .web.web_path = strenv(UI_DIR)' "$config_file"
    sed -i 's|/var/lib/pymc_repeater|/var/lib/openhop_repeater|g; s|/etc/pymc_repeater|/etc/openhop_repeater|g; s|/var/log/pymc_repeater|/var/log/openhop_repeater|g; s|/opt/pymc_repeater|/opt/openhop_repeater|g' "$config_file" 2>/dev/null || true
    chown "$REPEATER_USER:$REPEATER_GROUP" "$config_file" "$OPENHOP_CONFIG_DIR/config.yaml.example" 2>/dev/null || true
}

install_openhop_python_package() {
    print_info "Creating/updating OpenHop virtual environment..."
    python3 -m venv --system-site-packages "$OPENHOP_VENV_DIR"
    "$OPENHOP_VENV_PYTHON" -m pip install --upgrade pip setuptools wheel

    print_info "Installing OpenHop Repeater Python package..."
    if [[ -d "$OPENHOP_SOURCE_DIR/.git" ]]; then
        git -C "$OPENHOP_SOURCE_DIR" fetch --tags 2>/dev/null || true
        local git_version
        git_version=$("$OPENHOP_VENV_PYTHON" -m pip show setuptools-scm >/dev/null 2>&1 && cd "$OPENHOP_SOURCE_DIR" && "$OPENHOP_VENV_PYTHON" -m setuptools_scm 2>/dev/null || true)
        [[ -n "$git_version" ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="$git_version"
    fi

    "$OPENHOP_VENV_PYTHON" -m pip install --upgrade --no-cache-dir "$OPENHOP_SOURCE_DIR[hardware]"
}

install_openhop_service_files() {
    cp "$OPENHOP_SOURCE_DIR/manage.sh" "$OPENHOP_INSTALL_DIR/manage.sh"
    cp "$OPENHOP_SOURCE_DIR/openhop-repeater.service" "$OPENHOP_INSTALL_DIR/openhop-repeater.service"
    cp "$OPENHOP_SOURCE_DIR/openhop-repeater.service" "/etc/systemd/system/${OPENHOP_SERVICE_NAME}.service"
    cp "$OPENHOP_SOURCE_DIR/radio-settings.json" "$OPENHOP_DATA_DIR/" 2>/dev/null || true
    cp "$OPENHOP_SOURCE_DIR/radio-presets.json" "$OPENHOP_DATA_DIR/" 2>/dev/null || true

    chmod +x "$OPENHOP_INSTALL_DIR/manage.sh" 2>/dev/null || true
    chown root:root "$OPENHOP_INSTALL_DIR" "$OPENHOP_INSTALL_DIR/manage.sh" "$OPENHOP_INSTALL_DIR/openhop-repeater.service" 2>/dev/null || true
    systemctl daemon-reload
    systemctl enable "$OPENHOP_SERVICE_NAME"
}

configure_repeater_service_management() {
    mkdir -p /etc/sudoers.d
    cat > /etc/sudoers.d/openhop-repeater <<'EOF'
# Allow repeater user to manage the openhop-repeater service without password.
repeater ALL=(root) NOPASSWD: /usr/bin/systemctl restart openhop-repeater, /usr/bin/systemctl stop openhop-repeater, /usr/bin/systemctl start openhop-repeater, /usr/bin/systemctl status openhop-repeater, /usr/local/bin/pymc-do-upgrade
EOF
    chmod 0440 /etc/sudoers.d/openhop-repeater

    if command -v pkaction &>/dev/null; then
        mkdir -p /etc/polkit-1/rules.d
        cat > /etc/polkit-1/rules.d/10-openhop-repeater.rules <<'EOF'
polkit.addRule(function(action, subject) {
    if (action.id == "org.freedesktop.systemd1.manage-units" &&
        action.lookup("unit") == "openhop-repeater.service" &&
        subject.user == "repeater") {
        return polkit.Result.YES;
    }
});
EOF
        chmod 0644 /etc/polkit-1/rules.d/10-openhop-repeater.rules
    fi
}

install_openhop_ota_helper() {
    cat > /usr/local/bin/pymc-do-upgrade <<'EOF'
#!/bin/bash
# Invoked by the repeater service user via sudo for OpenHop OTA upgrades.
set -e

CHANNEL="${1:-main}"
PRETEND_VERSION="${2:-}"
VENV_DIR="/opt/openhop_repeater/venv"
VENV_PYTHON="$VENV_DIR/bin/python"
SERVICE_UNIT="/etc/systemd/system/openhop-repeater.service"
R2_BASE_URL="https://wheel.pymc.dev/pymc_build_deps"

if ! [[ "$CHANNEL" =~ ^[a-zA-Z0-9._/-]{1,80}$ ]]; then
    echo "Invalid channel name: $CHANNEL" >&2
    exit 1
fi

[[ -n "$PRETEND_VERSION" ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="$PRETEND_VERSION"

if [[ ! -x "$VENV_PYTHON" ]]; then
    python3 -m venv --system-site-packages "$VENV_DIR"
    "$VENV_PYTHON" -m pip install --upgrade pip setuptools wheel >/dev/null 2>&1 || true
fi

if [[ -f "$SERVICE_UNIT" ]]; then
    if grep -q 'PYTHONPATH' "$SERVICE_UNIT" 2>/dev/null; then
        sed -i '/^Environment=.*PYTHONPATH/d' "$SERVICE_UNIT"
    fi
    if grep -q 'WorkingDirectory=/opt/openhop_repeater' "$SERVICE_UNIT" 2>/dev/null; then
        sed -i 's|WorkingDirectory=/opt/openhop_repeater|WorkingDirectory=/var/lib/openhop_repeater|' "$SERVICE_UNIT"
    fi
    if grep -q 'WorkingDirectory=/opt/pymc_repeater\|WorkingDirectory=/var/lib/pymc_repeater' "$SERVICE_UNIT" 2>/dev/null; then
        sed -i 's|WorkingDirectory=/opt/pymc_repeater|WorkingDirectory=/var/lib/openhop_repeater|' "$SERVICE_UNIT"
        sed -i 's|WorkingDirectory=/var/lib/pymc_repeater|WorkingDirectory=/var/lib/openhop_repeater|' "$SERVICE_UNIT"
    fi
    if grep -q 'ExecStart=/usr/bin/python3' "$SERVICE_UNIT" 2>/dev/null; then
        sed -i "s|ExecStart=/usr/bin/python3|ExecStart=$VENV_PYTHON|" "$SERVICE_UNIT"
    fi
    if grep -q 'ExecStart=/opt/pymc_repeater/venv/bin/python' "$SERVICE_UNIT" 2>/dev/null; then
        sed -i "s|ExecStart=/opt/pymc_repeater/venv/bin/python|ExecStart=$VENV_PYTHON|" "$SERVICE_UNIT"
    fi
    systemctl daemon-reload
fi

rm -rf /opt/openhop_repeater/repeater \
       /opt/openhop_repeater/openhop-repeater \
       /opt/pymc_repeater/repeater \
       /opt/pymc_repeater/pymc-repeater 2>/dev/null || true

python3 -m pip uninstall -y openhop_repeater openhop_core pymc_repeater pymc_core 2>/dev/null || true

case "$(uname -m)" in
    aarch64) arch_tag="arm64"; platform_tag="aarch64" ;;
    armv7l|armv7) arch_tag="armv7"; platform_tag="armv7l" ;;
    x86_64) arch_tag="x86_64"; platform_tag="x86_64" ;;
    *) arch_tag=""; platform_tag="" ;;
esac

if [[ -n "$arch_tag" ]]; then
    py_tag=$("$VENV_PYTHON" -c 'import sys; v=f"cp{sys.version_info.major}{sys.version_info.minor}"; print(f"{v}-{v}")' 2>/dev/null || echo "cp311-cp311")
    "$VENV_PYTHON" -m pip install --find-links "${R2_BASE_URL}/${arch_tag}/${platform_tag}/${py_tag}/index.html" --no-cache-dir "pycryptodome>=3.23.0" "PyNaCl>=1.5.0" cffi "pyyaml>=6.0.0" 2>/dev/null || true
fi

"$VENV_PYTHON" -m pip install --upgrade --no-cache-dir "openhop_repeater[hardware] @ git+https://github.com/openhop-dev/openhop_repeater.git@${CHANNEL}"

radio_base_url="https://raw.githubusercontent.com/openhop-dev/openhop_repeater/${CHANNEL}"
mkdir -p /var/lib/openhop_repeater
wget -qO /var/lib/openhop_repeater/radio-settings.json "${radio_base_url}/radio-settings.json" 2>/dev/null || true
wget -qO /var/lib/openhop_repeater/radio-presets.json "${radio_base_url}/radio-presets.json" 2>/dev/null || true
EOF
    chmod 0755 /usr/local/bin/pymc-do-upgrade
}

restart_openhop_service() {
    if ! command -v systemctl &>/dev/null; then
        print_error "systemctl is required to manage openhop-repeater.service."
        return 1
    fi
    systemctl daemon-reload
    systemctl restart "$OPENHOP_SERVICE_NAME"
}

ensure_openhop_repeater_backend() {
    install_system_packages
    ensure_mikefarah_yq
    fetch_openhop_repeater_source
    migrate_legacy_repeater_paths
    ensure_repeater_user_and_dirs
    ensure_openhop_config
    install_openhop_python_package
    install_openhop_service_files
    configure_repeater_service_management
    install_openhop_ota_helper
    restart_openhop_service
    print_success "OpenHop Repeater backend installed and started."
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
    echo -e "  ${DIM}Mode: Install OpenHop Repeater + Console${NC}"
    echo ""

    if console_installed || legacy_console_installed; then
        if ! prompt_yes_no "Console dashboard already installed; reinstall?" "n"; then
            print_info "Install cancelled."
            return 0
        fi
    fi

    print_step 1 3 "Installing OpenHop Repeater backend"
    ensure_openhop_repeater_backend || {
        print_repeater_missing_help
        return 1
    }

    print_step 2 3 "Installing Console dashboard"
    install_dashboard

    print_step 3 3 "Restarting OpenHop Repeater"
    restart_openhop_service

    local ip
    ip=$(hostname -I 2>/dev/null | awk '{print $1}')
    echo ""
    echo -e "${GREEN}${BOLD}OpenHop Stack Installed${NC}"
    echo ""
    echo -e "    OpenHop Repeater: ${CYAN}v$(get_repeater_version)${NC}"
    echo -e "    OpenHop Console: ${CYAN}v$(get_console_version)${NC}"
    echo -e "    Repeater config:  ${CYAN}$OPENHOP_CONFIG_DIR/config.yaml${NC}"
    echo -e "    Console path:     ${CYAN}$UI_DIR${NC}"
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
    echo -e "  ${DIM}Mode: Upgrade OpenHop Repeater + Console${NC}"
    echo ""

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

    print_step 1 3 "Updating OpenHop Repeater backend"
    ensure_openhop_repeater_backend || {
        print_repeater_missing_help
        return 1
    }

    print_step 2 3 "Updating Console dashboard"
    install_dashboard

    print_step 3 3 "Restarting OpenHop Repeater"
    restart_openhop_service

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
    echo -e "    OpenHop Repeater: ${CYAN}v$(get_repeater_version)${NC}"
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
  install        Install OpenHop Repeater backend and Console dashboard
  upgrade        Upgrade OpenHop Repeater and refresh Console dashboard assets
  uninstall      Remove Console dashboard and this repo
  -h, --help     Show this help

Flags:
  --yes, -y      Auto-confirm all prompts (also: ASSUME_YES=1)

Environment:
  OPENHOP_REPEATER_REPO   Repeater git repository (default: $OPENHOP_REPEATER_REPO)
  OPENHOP_REPEATER_REF    Repeater branch/tag/ref (default: $OPENHOP_REPEATER_REF)
  OPENHOP_REPEATER_SOURCE_DIR  Local source checkout (default: $OPENHOP_SOURCE_DIR)
  OPENHOP_CONSOLE_DIR    Install directory (default: /opt/openhop_console)
  OPENHOP_CONSOLE_REPO   GitHub repo for release assets (default: $UI_REPO)
  OPENHOP_UI_TARBALL     Preferred release asset (default: $UI_TARBALL)

Notes:
  - install bootstraps Debian packages, OpenHop Repeater, systemd, config,
    and the Console dashboard.
  - Repeater radio/protocol logic remains upstream OpenHop code:
      https://github.com/openhop-dev/openhop_repeater
  - A clean LXC starts in no-radio mode until serial/SPI hardware is configured.
  - Legacy PYMC_* environment variables are accepted for compatibility.
EOF
}

print_deprecated_subcommand() {
    local cmd="$1"
    local arg="$2"
    print_error "\`$cmd $arg\` has been deprecated."
    echo "    The Full Stack / Console-only distinction no longer exists."
    echo "    This script now installs OpenHop Repeater and OpenHop Console together."
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
