#!/usr/bin/env bash
set -Eeuo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

if [[ "${EUID}" -ne 0 ]]; then
	echo "Please run as root: sudo ./bootstrap.sh" >&2
	exit 1
fi

source scripts/lib.sh
source scripts/apt.sh
source scripts/user.sh
source scripts/handoff.sh
source scripts/ssh.sh

ledge_require_ubuntu

ledge_log "Bootstrap phase"
ledge_install_packages
ledge_configure_unattended_upgrades
ledge_configure_admin_user
ledge_configure_ssh
ledge_handoff_repository

ledge_log "Cleaning bootstrap repository"

target="/home/${LEDGE_ADMIN_USER:-jjj}/Development/ledge"
current="$(pwd)"

if [[ "${current}" != "${target}" ]]; then
	rm -rf "${current}"
fi

cat <<MSG

Bootstrap complete.

Continue as:

    ssh ${LEDGE_ADMIN_USER:-jjj}@<host>
    cd ~/Development/ledge
    sudo ./configure.sh

MSG
