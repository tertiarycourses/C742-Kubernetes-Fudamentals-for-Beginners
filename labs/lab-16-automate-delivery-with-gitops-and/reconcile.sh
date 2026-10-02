#!/usr/bin/env bash
# Lab 16 — a minimal GitOps reconciliation loop.
#
# This is what Argo CD and Flux do continuously, reduced to its essentials:
#   1. Read the desired state from the Git repository
#   2. Diff it against the live cluster
#   3. Apply the difference
#
# The important property is that it is a LOOP, not a one-shot deploy. Manual
# out-of-band changes (drift) are corrected on the next pass, automatically.
set -uo pipefail

REPO_DIR="${1:-gitops-repo}"
MANIFESTS="${REPO_DIR}/manifests"

echo "=== GitOps reconciliation ==="
echo "Desired state:  ${MANIFESTS} (git)"
echo "Actual state:   the live cluster"
echo

echo "--- 1. Detect drift -------------------------------------------"
if kubectl diff -f "${MANIFESTS}/" >/tmp/gitops-drift.txt 2>&1; then
  echo "No drift: the cluster already matches Git."
else
  echo "DRIFT DETECTED — the cluster differs from the declared state:"
  sed -n '1,40p' /tmp/gitops-drift.txt
fi
echo

echo "--- 2. Reconcile ----------------------------------------------"
kubectl apply -f "${MANIFESTS}/"
echo

echo "--- 3. Verify -------------------------------------------------"
DESIRED=$(grep -E '^\s*replicas:' "${MANIFESTS}/deployment.yaml" | head -1 | awk '{print $2}')
ACTUAL=$(kubectl get deploy gitops-app -n kcna-lab -o jsonpath='{.spec.replicas}' 2>/dev/null)
echo "Declared in Git: ${DESIRED} replicas"
echo "Live in cluster: ${ACTUAL} replicas"
if [ "${DESIRED}" = "${ACTUAL}" ]; then
  echo "RECONCILED — actual state now matches desired state."
else
  echo "STILL DIVERGENT — investigate."
fi
