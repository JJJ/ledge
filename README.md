# Ledge

**Light Edge Server**

Ledge transforms a minimal Ubuntu server into a secure edge gateway.

## Features

- WireGuard
- nftables
- Automatic updates
- SSH hardening
- IPv4 forwarding
- Small footprint
- Idempotent-ish configuration

## Philosophy

Applications belong elsewhere.

Ledge owns the public IP.

## Target

- Ubuntu 26.04 LTS
- Small VPS with one public IPv4 address
- One or more private machines connecting over WireGuard

## Quick start

```bash
sudo ./bootstrap.sh
```

Then rerun configuration safely with:

```bash
sudo ./install.sh
```
