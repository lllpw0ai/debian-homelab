#!/usr/bin/env bash
# Nightly homelab backup: stop containers, back up with restic, restart, prune old snapshots.
set -euo pipefail
source /root/.restic.env

HOMELAB="/home/llpw0ai/homelab"

compose_all() {   # run "docker compose <action>" in every service folder
  for f in "$HOMELAB"/*/compose.yaml; do
    [[ "$f" == */technitium/* ]] && continue
    docker compose -f "$f" "$1" || true
  done
}

on_exit() {
  rc=$?
  compose_all start
  if [ "$rc" -ne 0 ]; then
    curl -s -H "Priority: high" -d "Homelab backup FAILED (exit $rc)" "https://ntfy.sh/$NTFY_TOPIC" > /dev/null
  fi
}
trap on_exit EXIT

compose_all stop   # stop containers so databases are saved in a consistent state
restic backup "$HOMELAB" --exclude "$HOMELAB/*/cache" --tag homelab
restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune
