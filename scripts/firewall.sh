#!/usr/bin/env bash

ledge_configure_nftables() {
  ledge_log "Configuring nftables baseline"

  cat >/etc/nftables.conf <<'NFT'
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
  chain input {
    type filter hook input priority 0;
    policy drop;

    ct state established,related accept
    iif lo accept

    # ICMP keeps the Internet debuggable.
    ip protocol icmp accept
    ip6 nexthdr ipv6-icmp accept

    # SSH.
    tcp dport 22 accept

    # WireGuard. Keep this closed until configured if desired.
    udp dport 51820 accept
  }

  chain forward {
    type filter hook forward priority 0;
    policy drop;

    ct state established,related accept

    # WireGuard forwarding rules will live here.
    iifname "wg0" accept
    oifname "wg0" accept
  }

  chain output {
    type filter hook output priority 0;
    policy accept;
  }
}

table ip nat {
  chain prerouting {
    type nat hook prerouting priority -100;
    policy accept;

    # DNAT examples, enable once the Pi tunnel IP is known:
    # tcp dport { 25, 80, 443, 465, 587, 993 } dnat to 10.44.0.2
  }

  chain postrouting {
    type nat hook postrouting priority 100;
    policy accept;

    # Masquerade WireGuard clients out via the public interface.
    ip saddr 10.44.0.0/24 masquerade
  }
}
NFT

  systemctl enable nftables
  systemctl restart nftables
}
