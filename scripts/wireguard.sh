#!/usr/bin/env bash

ledge_prepare_wireguard() {
  ledge_log "Preparing WireGuard"

  install -d -m 0700 /etc/wireguard

  if [[ ! -f /etc/wireguard/server.key ]]; then
    wg genkey | tee /etc/wireguard/server.key | wg pubkey >/etc/wireguard/server.pub
    chmod 0600 /etc/wireguard/server.key
    chmod 0644 /etc/wireguard/server.pub
  fi

  if [[ ! -f /etc/wireguard/wg0.conf ]]; then
    local private_key
    private_key="$(cat /etc/wireguard/server.key)"

    cat >/etc/wireguard/wg0.conf <<WGCONF
[Interface]
Address = 10.44.0.1/24
ListenPort = 51820
PrivateKey = ${private_key}

# Add Pi peers below, for example:
# [Peer]
# PublicKey = <PI_PUBLIC_KEY>
# AllowedIPs = 10.44.0.2/32
WGCONF

    chmod 0600 /etc/wireguard/wg0.conf
  fi

  systemctl enable wg-quick@wg0
  systemctl restart wg-quick@wg0

  ledge_log "WireGuard public key"
  cat /etc/wireguard/server.pub
}
