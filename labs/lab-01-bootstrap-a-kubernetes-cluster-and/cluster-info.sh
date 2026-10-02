#!/usr/bin/env bash
# Lab 1 — dump the cluster component inventory in one pass.
# Usage: bash cluster-info.sh > my-cluster-inventory.txt
set -uo pipefail

echo "===== CLUSTER VERSION ====="
kubectl version

echo; echo "===== NODES ====="
kubectl get nodes -o wide

echo; echo "===== NODE CAPACITY & CONDITIONS ====="
kubectl describe node minikube | sed -n '/Capacity:/,/Allocated resources:/p'

echo; echo "===== CONTROL-PLANE COMPONENTS (kube-system) ====="
kubectl get pods -n kube-system -o wide

echo; echo "===== CLUSTER ENDPOINTS ====="
kubectl cluster-info

echo; echo "===== API HEALTH ====="
kubectl get --raw='/readyz?verbose' 2>/dev/null | head -20

echo; echo "===== CONTAINER RUNTIME ====="
kubectl get node minikube -o jsonpath='{.status.nodeInfo.containerRuntimeVersion}'; echo

echo; echo "===== API RESOURCES ====="
kubectl api-resources --sort-by=name | head -40
