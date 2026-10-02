# Lab 11 — Explore Serverless, Open Standards and the CNCF Landscape

**Topic 3** · Cloud Native Architecture and Scalability  
**Objective:** Identify stakeholder demands and open standards that constrain a cloud native technical blueprint.

## What you'll do

The learner examines the open standards that keep Kubernetes portable — OCI, CRI, CNI, CSI — by inspecting the cluster's own implementations, models event-driven scale-to-zero, and maps candidate CNCF projects to the blueprint's requirements.

**What you'll build:** A standards-and-projects selection matrix justifying each component of the blueprint

**Tools and objects used:** CNCF landscape, OCI, CRI, CNI, CSI, Knative and KEDA concepts, ConfigMap, scale-to-zero

## Files in this folder

| File | What it is |
|---|---|
| `standards-matrix.md` | Worksheet mapping each standard to its cluster implementation. |
| `configmap-scaling-policy.yaml` | Event-driven scaling policy expressed as config. |
| `deployment-scale-to-zero.yaml` | Deployment demonstrating scale-to-zero and back. |
| `cncf-selection.csv` | Mock evaluation of 8 CNCF projects against blueprint criteria. |

## Before you start

```bash
# a running cluster and the shared namespace
kubectl get nodes
kubectl get ns kcna-lab || kubectl apply -f ../lab-02-kubernetes-api/namespace.yaml
cd labs/lab-11-explore-serverless-open-standards-and
```

## Step-by-step

### 1. Identify the CRI implementation actually running your containers

```bash
kubectl get nodes -o jsonpath='{.items[*].status.nodeInfo.containerRuntimeVersion}'
```

### 2. Identify the CNI plugin providing the Pod network

```bash
kubectl get pods -n kube-system -o name | grep -Ei 'cni|calico|flannel|kindnet'
```

### 3. Identify the CSI driver and StorageClass provisioner in use

```bash
kubectl get storageclass -o jsonpath='{.items[*].provisioner}'
```

### 4. Confirm the OCI image spec by reading an image's architecture and layers

```bash
kubectl get pod -n kcna-lab -o jsonpath='{.items[0].status.containerStatuses[0].imageID}'
```

### 5. Apply the event-driven scaling policy as configuration

```bash
kubectl apply -f configmap-scaling-policy.yaml
```

### 6. Deploy the workload that will demonstrate scale-to-zero

```bash
kubectl apply -f deployment-scale-to-zero.yaml
```

### 7. Scale the workload to zero to model the serverless idle state

```bash
kubectl scale deploy scale-to-zero -n kcna-lab --replicas=0
```

### 8. Confirm no Pods and therefore no compute cost while idle

```bash
kubectl get deploy scale-to-zero -n kcna-lab
```

### 9. Scale back up on demand and measure the cold-start latency

```bash
time kubectl scale deploy scale-to-zero -n kcna-lab --replicas=3 --timeout=60s
```

### 10. Complete cncf-selection.csv and standards-matrix.md for your blueprint

```bash
cat cncf-selection.csv
```

## Test it

Your standards-matrix.md names the actual CRI, CNI and CSI implementations found in this cluster, and the scale-to-zero Deployment reports 0/0 replicas when idle and 3/3 after scaling back up.

## Clean up

```bash
# Remove the objects this lab created (safe to skip if you have cluster room)
kubectl delete -f . --ignore-not-found 2>/dev/null || true
```

---

*Kubernetes Fundamentals for Beginners (C742) · Tertiary Infotech Academy Pte Ltd · v1.0*
