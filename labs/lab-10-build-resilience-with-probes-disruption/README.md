# Lab 10 — Build Resilience with Probes, Disruption Budgets and Multi-Tier Architecture

**Topic 3** · Cloud Native Architecture and Scalability  
**Objective:** Prepare a technical blueprint for a resilient multi-tier cloud native architecture and prove its failure behaviour.

## What you'll do

The learner deploys a three-tier application, configures liveness, readiness and startup probes, deliberately fails a container to watch Kubernetes self-heal, and protects availability during maintenance with a PodDisruptionBudget.

**What you'll build:** A three-tier application with health probes and a PodDisruptionBudget, plus a documented blueprint

**Tools and objects used:** liveness/readiness/startup probes, PodDisruptionBudget, Deployment, Service, resource limits

## Files in this folder

| File | What it is |
|---|---|
| `tier-frontend.yaml` | Frontend Deployment + Service with readiness probe. |
| `tier-api.yaml` | API tier with liveness, readiness and startup probes. |
| `tier-database.yaml` | Database tier with a persistent volume. |
| `pdb-api.yaml` | PodDisruptionBudget requiring minAvailable: 2. |
| `blueprint-template.md` | Technical blueprint worksheet — components, interfaces, NFRs, trade-offs. |

## Before you start

```bash
# a running cluster and the shared namespace
kubectl get nodes
kubectl get ns kcna-lab || kubectl apply -f ../lab-02-kubernetes-api/namespace.yaml
cd labs/lab-10-build-resilience-with-probes-disruption
```

## Step-by-step

### 1. Deploy the three tiers of the application

```bash
kubectl apply -f tier-database.yaml -f tier-api.yaml -f tier-frontend.yaml
```

### 2. Confirm all three tiers are running and their Services resolve

```bash
kubectl get deploy,svc,pods -n kcna-lab -l tier
```

### 3. Inspect the probe configuration on the API tier

```bash
kubectl get deploy api -n kcna-lab -o jsonpath='{.spec.template.spec.containers[0].livenessProbe}' | python3 -m json.tool
```

### 4. Watch a readiness probe gate traffic — the Pod is Running but not Ready

```bash
kubectl get pods -n kcna-lab -l tier=api -o wide
```

### 5. Break the health endpoint deliberately to trigger the liveness probe

```bash
kubectl exec -n kcna-lab deploy/api -- rm -f /usr/share/nginx/html/healthz
```

### 6. Watch Kubernetes restart the unhealthy container automatically

```bash
kubectl get pods -n kcna-lab -l tier=api -w --timeout=120s
```

### 7. Confirm the restart count and the probe failure event

```bash
kubectl describe pod -n kcna-lab -l tier=api | grep -A5 'Liveness probe failed'
```

### 8. Apply a PodDisruptionBudget to protect availability during maintenance

```bash
kubectl apply -f pdb-api.yaml && kubectl get pdb -n kcna-lab
```

### 9. Attempt a node drain and observe the PDB blocking excessive eviction

```bash
kubectl drain minikube --ignore-daemonsets --delete-emptydir-data --dry-run=server 2>&1 | head -15
```

### 10. Complete blueprint-template.md documenting components, interfaces and NFRs

```bash
cat blueprint-template.md
```

## Test it

The API container restarts automatically after the health file is removed (RESTARTS increments and a Liveness probe failed event is logged), and kubectl get pdb reports ALLOWED DISRUPTIONS consistent with minAvailable: 2.

## Clean up

```bash
# Remove the objects this lab created (safe to skip if you have cluster room)
kubectl delete -f . --ignore-not-found 2>/dev/null || true
```

---

*Kubernetes Fundamentals for Beginners (C742) · Tertiary Infotech Academy Pte Ltd · v1.0*
