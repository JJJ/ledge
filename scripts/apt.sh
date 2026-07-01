#!/usr/bin/env bash

ledge_install_packages() {
  ledge_log "Installing packages"
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apt-listchanges \
    curl \
    dnsutils \
    htop \
    mtr-tiny \
    nftables \
    tcpdump \
    unattended-upgrades \
    vim \
    wireguard
}

ledge_configure_unattended_upgrades() {
  ledge_log "Configuring unattended upgrades"

  cat >/etc/apt/apt.conf.d/20auto-upgrades <<'APTCONF'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::AutocleanInterval "7";
APTCONF

  cat >/etc/apt/apt.conf.d/52ledge-unattended-upgrades <<'APTCONF'
Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";
Unattended-Upgrade::Remove-New-Unused-Dependencies "true";
Unattended-Upgrade::Automatic-Reboot "true";
Unattended-Upgrade::Automatic-Reboot-Time "04:00";
APTCONF
}
