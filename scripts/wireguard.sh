#!/usr/bin/env bash

ledge_prepare_wireguard() {
  ledge_log "Preparing WireGuard"

  install -d -m 0700 /etc/wireguard

  if [[ ! -f /etc/wireguard/server.key ]]; then
    wg genkey | tee /etc/wireguard/server.key | wg pubkey >/etc/wireguard/server.pub
    chmod 0600 /etc/wireguard/server.key
    chmod 0644 /etc/wireguard/server.pub
  fi

  if [[ ! -f /etc/wireguard/${LEDGE_WIREGUARD_INTERFACE}.conf ]]; then
    local private_key
    private_key="$(cat /etc/wireguard/server.key)"

    cat >/etc/wireguard/${LEDGE_WIREGUARD_INTERFACE}.conf <<WGCONF
[Interface]
Address = ${LEDGE_WIREGUARD_ADDRESS}
ListenPort = ${LEDGE_WIREGUARD_PORT}
PrivateKey = ${private_key}

# Add Pi peers below, for example:
# [Peer]
# PublicKey = <PI_PUBLIC_KEY>
# AllowedIPs = 10.44.0.2/32
WGCONF

    chmod 0600 /etc/wireguard/${LEDGE_WIREGUARD_INTERFACE}.conf
  fi

  systemctl enable wg-quick@${LEDGE_WIREGUARD_INTERFACE}
  systemctl restart wg-quick@${LEDGE_WIREGUARD_INTERFACE}

  ledge_log "WireGuard public key"
  cat /etc/wireguard/server.pub
}
