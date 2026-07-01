#!/usr/bin/env bash
set -Eeuo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

if [[ "${EUID}" -ne 0 ]]; then
  echo "Please run as root: sudo ./bootstrap.sh" >&2
  exit 1
fi

echo "==> Bootstrapping Ledge"

./install.sh

echo "==> Ledge bootstrap complete"
