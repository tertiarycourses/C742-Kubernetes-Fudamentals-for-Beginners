#!/usr/bin/env bash
# Lab 14 — probe the Service continuously and record ANY failed request.
# Run this in the background BEFORE starting a rollout:
#   bash uptime-probe.sh > uptime.log 2>&1 &
# Then after the rollout:
#   kill %1; grep -c FAIL uptime.log
set -uo pipefail

NS=kcna-lab
SVC=app-release
TOTAL=0
FAILED=0

echo "Probing ${SVC}.${NS} every 0.5s. Ctrl-C or kill to stop."
while true; do
  TOTAL=$((TOTAL + 1))
  if kubectl run probe-$$-$TOTAL -n "$NS" --rm -q --restart=Never \
       --image=curlimages/curl --command -- \
       curl -sf --max-time 2 "http://${SVC}.${NS}.svc.cluster.local" >/dev/null 2>&1; then
    printf "OK   %s request %d\n" "$(date +%T)" "$TOTAL"
  else
    FAILED=$((FAILED + 1))
    printf "FAIL %s request %d  (total failures: %d)\n" "$(date +%T)" "$TOTAL" "$FAILED"
  fi
  sleep 0.5
done
