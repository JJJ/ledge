#!/usr/bin/env bash
set -Eeuo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

if [[ "${EUID}" -ne 0 ]]; then
	echo "Please run as root: sudo ./configure.sh" >&2
	exit 1
fi

source scripts/lib.sh
source scripts/sysctl.sh
source scripts/firewall.sh
source scripts/wireguard.sh

ledge_require_ubuntu

ledge_log "Configure phase"
ledge_configure_sysctl
ledge_configure_nftables
ledge_prepare_wireguard

ledge_log "Configure complete"
