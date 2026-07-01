#!/usr/bin/env bash

ledge_log() {
  printf '\n==> %s\n' "$*"
}

ledge_warn() {
  printf '\nWARN: %s\n' "$*" >&2
}

ledge_require_ubuntu() {
  if [[ ! -r /etc/os-release ]]; then
    echo "Cannot identify OS" >&2
    exit 1
  fi

  # shellcheck disable=SC1091
  source /etc/os-release

  if [[ "${ID:-}" != "ubuntu" ]]; then
    echo "Ledge currently targets Ubuntu. Found: ${PRETTY_NAME:-unknown}" >&2
    exit 1
  fi

  if [[ "${VERSION_ID:-}" != "24.04" ]]; then
    ledge_warn "Expected Ubuntu 24.04. Found: ${PRETTY_NAME:-unknown}"
  fi
}
