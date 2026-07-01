#!/usr/bin/env bash

ledge_configure_ssh() {
  ledge_log "Hardening SSH"

  install -d -m 0755 /etc/ssh/sshd_config.d

  cat >/etc/ssh/sshd_config.d/99-ledge.conf <<'SSHCONF'
PermitRootLogin no
PasswordAuthentication no
KbdInteractiveAuthentication no
ChallengeResponseAuthentication no
PubkeyAuthentication yes
X11Forwarding no
AllowTcpForwarding yes
ClientAliveInterval 300
ClientAliveCountMax 2
SSHCONF

  sshd -t
  systemctl reload ssh || systemctl restart ssh
}
