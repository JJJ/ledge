# Networking Model

Ledge owns the public IPv4 address.

Private infrastructure connects outbound to Ledge over WireGuard.

```text
Internet
  ↓
Ledge public IP
  ↓
WireGuard
  ↓
Private host / Raspberry Pi
```

For mail, both inbound and outbound traffic should traverse Ledge so reverse DNS, SPF, and SMTP reputation line up with the public IP.
