#!/usr/bin/env bash

ledge_lock_root_ssh() {
	ledge_log "Locking root SSH login"

	local admin_user="${LEDGE_ADMIN_USER:-jjj}"

	if ! id "${admin_user}" >/dev/null 2>&1; then
		echo "Admin user '${admin_user}' does not exist. Refusing to disable root SSH." >&2
		exit 1
	fi

	if ! groups "${admin_user}" | grep -qw sudo; then
		echo "Admin user '${admin_user}' is not in sudo group. Refusing to disable root SSH." >&2
		exit 1
	fi

	sed -i 's/^PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config.d/99-ledge.conf

	sshd -t
	systemctl reload ssh || systemctl restart ssh

	ledge_log "Root SSH login disabled"
}
