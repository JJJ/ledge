#!/usr/bin/env bash

ledge_configure_sysctl() {
  ledge_log "Configuring kernel forwarding"

  cat >/etc/sysctl.d/99-ledge.conf <<'SYSCTL'
net.ipv4.ip_forward=1
net.ipv4.conf.all.rp_filter=0
net.ipv4.conf.default.rp_filter=0
net.ipv6.conf.all.forwarding=0
SYSCTL

  sysctl --system >/dev/null
}
