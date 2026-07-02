#!/usr/bin/env bash

ledge_handoff_repository() {
	local username="${LEDGE_ADMIN_USER}"
	local source_dir="${LEDGE_SOURCE_DIR:-$(pwd)}"
	local target_parent="/home/${username}/${LEDGE_DEVELOPMENT_DIR}"
	local target_dir="${target_parent}/${LEDGE_REPOSITORY_NAME}"

	ledge_log "Handing off repository to ${username}: ${target_dir}"

	if ! id "${username}" >/dev/null 2>&1; then
		echo "Admin user '${username}' does not exist. Refusing repository handoff." >&2
		exit 1
	fi

	install -d -m 0755 -o "${username}" -g "${username}" "${target_parent}"

	if [[ "${source_dir}" == "${target_dir}" ]]; then
		chown -R "${username}:${username}" "${target_dir}"
		return
	fi

	if [[ -d "${target_dir}/.git" ]]; then
		chown -R "${username}:${username}" "${target_dir}"
		return
	fi

	rsync -a --delete \
		--exclude='.git/index.lock' \
		"${source_dir}/" "${target_dir}/"

	chown -R "${username}:${username}" "${target_dir}"
}
