# Lab 14 — Perform Zero-Downtime Rolling Updates and Canary Releases

**Topic 5** · Kubernetes Application Deployment and Management  
**Objective:** Implement a controlled release and roll it back, monitoring solution status throughout.

## What you'll do

The learner tunes a Deployment's rolling-update strategy, releases a new version while continuously probing for downtime, deliberately deploys a broken image to see the rollout stall, rolls back, then runs a weighted canary release.

**What you'll build:** A verified zero-downtime rolling update, a recovered failed rollout, and a working canary split

**Tools and objects used:** Deployment strategy, maxSurge/maxUnavailable, readiness probes, kubectl rollout, canary via replica weighting

## Files in this folder

| File | What it is |
|---|---|
| `deployment-v1.yaml` | Version 1 with a tuned RollingUpdate strategy. |
| `deployment-v2-broken.yaml` | Version 2 with an invalid image — the rollout stalls. |
| `canary-stable.yaml` | Stable Deployment, 9 replicas, shared Service selector. |
| `canary-new.yaml` | Canary Deployment, 1 replica — a 10% traffic split. |
| `service-canary.yaml` | Service selecting both stable and canary Pods. |
| `uptime-probe.sh` | Loop that records any failed request during the release. |

## Before you start

```bash
# a running cluster and the shared namespace
kubectl get nodes
kubectl get ns kcna-lab || kubectl apply -f ../lab-02-kubernetes-api/namespace.yaml
cd labs/lab-14-perform-zero-downtime-rolling-updates
```

## Step-by-step

### 1. Deploy version 1 and review its rolling-update strategy

```bash
kubectl apply -f deployment-v1.yaml && kubectl get deploy app-release -n kcna-lab -o jsonpath='{.spec.strategy}'
```

### 2. Start the uptime probe so downtime would be recorded

```bash
bash uptime-probe.sh > uptime.log 2>&1 &
```

### 3. Roll out version 2 and watch replicas cut over incrementally

```bash
kubectl set image deploy/app-release app=nginx:1.27-alpine -n kcna-lab && kubectl rollout status deploy/app-release -n kcna-lab
```

### 4. Stop the probe and confirm no requests failed during the release

```bash
kill %1; grep -c FAIL uptime.log || echo 'zero failures'
```

### 5. Deploy a deliberately broken image and watch the rollout stall

```bash
kubectl apply -f deployment-v2-broken.yaml
```

### 6. Diagnose why the rollout is stuck rather than guessing

```bash
kubectl rollout status deploy/app-release -n kcna-lab --timeout=60s; kubectl get pods -n kcna-lab -l app=app-release
```

### 7. Roll back to the last good revision and confirm recovery

```bash
kubectl rollout undo deploy/app-release -n kcna-lab && kubectl rollout status deploy/app-release -n kcna-lab
```

### 8. Deploy the stable and canary Deployments behind one Service

```bash
kubectl apply -f canary-stable.yaml -f canary-new.yaml -f service-canary.yaml
```

### 9. Confirm the Service is load-balancing across both versions

```bash
kubectl get endpoints app-canary -n kcna-lab -o jsonpath='{.subsets[0].addresses[*].ip}'
```

### 10. Measure the actual traffic split, then promote or abort the canary

```bash
kubectl scale deploy app-canary -n kcna-lab --replicas=10 && kubectl scale deploy app-stable -n kcna-lab --replicas=0
```

## Test it

uptime.log records zero failed requests across the rolling update, the broken rollout is detected and reversed by kubectl rollout undo, and the canary Service lists endpoints from both Deployments before promotion.

## Clean up

```bash
# Remove the objects this lab created (safe to skip if you have cluster room)
kubectl delete -f . --ignore-not-found 2>/dev/null || true
```

---

*Kubernetes Fundamentals for Beginners (C742) · Tertiary Infotech Academy Pte Ltd · v1.0*
