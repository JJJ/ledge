#!/usr/bin/env bash

LEDGE_CONFIG_FILE="${LEDGE_CONFIG_FILE:-/etc/ledge/ledge.conf}"

ledge_log() {
	printf '\n==> %s\n' "$*"
}

ledge_warn() {
	printf '\nWARN: %s\n' "$*" >&2
}

ledge_error() {
	printf '\nERROR: %s\n' "$*" >&2
	exit 1
}

ledge_require_root() {
	if [[ "${EUID}" -ne 0 ]]; then
		ledge_error "Please run as root: sudo $0"
	fi
}

ledge_require_ubuntu() {
	if [[ ! -r /etc/os-release ]]; then
		ledge_error "Cannot identify OS"
	fi

	# shellcheck disable=SC1091
	source /etc/os-release

	if [[ "${ID:-}" != "ubuntu" ]]; then
		ledge_error "Ledge currently targets Ubuntu. Found: ${PRETTY_NAME:-unknown}"
	fi

	case "${VERSION_ID:-}" in
		24.04|26.04)
			;;
		*)
			ledge_warn "Expected Ubuntu 24.04 or 26.04. Found: ${PRETTY_NAME:-unknown}"
			;;
	esac
}

ledge_install_default_config() {
	install -d -m 0755 /etc/ledge

	if [[ ! -f "${LEDGE_CONFIG_FILE}" ]]; then
		install -m 0644 files/etc/ledge/ledge.conf "${LEDGE_CONFIG_FILE}"
	fi
}

ledge_load_config() {
	ledge_install_default_config

	# shellcheck disable=SC1090
	source "${LEDGE_CONFIG_FILE}"

	: "${LEDGE_ADMIN_USER:=jjj}"
	: "${LEDGE_DEVELOPMENT_DIR:=Development}"
	: "${LEDGE_REPOSITORY_NAME:=ledge}"
	: "${LEDGE_WIREGUARD_INTERFACE:=wg0}"
	: "${LEDGE_WIREGUARD_PORT:=51820}"
	: "${LEDGE_WIREGUARD_NETWORK:=10.44.0.0/24}"
	: "${LEDGE_WIREGUARD_ADDRESS:=10.44.0.1/24}"
	: "${LEDGE_ENABLE_IPV6:=false}"
}

ledge_admin_home() {
	printf '/home/%s\n' "${LEDGE_ADMIN_USER}"
}

ledge_repo_dir() {
	printf '%s/%s/%s\n' "$(ledge_admin_home)" "${LEDGE_DEVELOPMENT_DIR}" "${LEDGE_REPOSITORY_NAME}"
}
