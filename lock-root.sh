#!/usr/bin/env bash
set -Eeuo pipefail

source scripts/common.sh
source scripts/lock-root.sh

ledge_require_root
ledge_lock_root_ssh
