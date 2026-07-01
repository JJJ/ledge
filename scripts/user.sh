#!/usr/bin/env bash

ledge_configure_admin_user() {
	local username="${LEDGE_ADMIN_USER:-jjj}"
	local source_keys="/root/.ssh/authorized_keys"
	local target_home="/home/${username}"
	local target_ssh="${target_home}/.ssh"
	local target_keys="${target_ssh}/authorized_keys"

	ledge_log "Configuring admin user: ${username}"

	if ! id "${username}" >/dev/null 2>&1; then
		adduser --disabled-password --gecos "" "${username}"
	fi

	usermod -aG sudo "${username}"

	install -d -m 0700 -o "${username}" -g "${username}" "${target_ssh}"

	if [[ -s "${source_keys}" ]]; then
		install -m 0600 -o "${username}" -g "${username}" "${source_keys}" "${target_keys}"
	else
		echo "No SSH keys found at ${source_keys}; cannot configure ${username} login." >&2
		exit 1
	fi

	echo "${username} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/90-ledge-${username}
	chmod 0440 /etc/sudoers.d/90-ledge-${username}
	visudo -cf /etc/sudoers.d/90-ledge-${username}
}
