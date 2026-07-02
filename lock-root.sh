#!/usr/bin/env bash
set -Eeuo pipefail

source scripts/lib.sh
ledge_require_root
ledge_load_config
source scripts/lock-root.sh

ledge_require_root
ledge_lock_root_ssh
