#!/usr/bin/env bash
set -Eeuo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

source scripts/lib.sh
ledge_require_root
ledge_require_ubuntu
ledge_load_config
source scripts/sysctl.sh
source scripts/firewall.sh
source scripts/wireguard.sh


ledge_log "Configure phase"
ledge_configure_sysctl
ledge_configure_nftables
ledge_prepare_wireguard

ledge_log "Configure complete"
