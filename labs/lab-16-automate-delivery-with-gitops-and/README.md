# Lab 16 — Automate Delivery with GitOps and CI/CD, and Conduct a System Review

**Topic 5** · Kubernetes Application Deployment and Management  
**Objective:** Implement regular system reviews to monitor solution status and adapt within a cloud native framework.

## What you'll do

The learner models the GitOps reconciliation loop with a Git-backed manifest repository, deliberately introduces configuration drift to watch reconciliation correct it, walks a CI/CD pipeline definition, then conducts a structured system review against the SLOs and records the adaptations.

**What you'll build:** A reconciling GitOps repository that self-corrects drift, plus a completed system review report

**Tools and objects used:** GitOps, Argo CD / Flux concepts, Git, CI/CD pipeline, reconciliation loop, SLOs, system review

## Files in this folder

| File | What it is |
|---|---|
| `gitops-repo/manifests/deployment.yaml` | The declared desired state in Git. |
| `gitops-repo/manifests/service.yaml` | Service manifest under version control. |
| `reconcile.sh` | Reconciliation loop simulating a GitOps agent. |
| `pipeline.yaml` | CI/CD pipeline definition — build, test, scan, update manifest. |
| `slo-targets.csv` | Mock SLO targets and 30-day actuals for 5 services. |
| `system-review-report.md` | Structured system review template. |

## Before you start

```bash
# a running cluster and the shared namespace
kubectl get nodes
kubectl get ns kcna-lab || kubectl apply -f ../lab-02-kubernetes-api/namespace.yaml
cd labs/lab-16-automate-delivery-with-gitops-and
```

## Step-by-step

### 1. Initialise the manifest repository as the single source of truth

```bash
cd gitops-repo && git init && git add . && git commit -m 'Declare desired state'
```

### 2. Apply the declared state to the cluster to establish the baseline

```bash
kubectl apply -f gitops-repo/manifests/
```

### 3. Confirm the cluster now matches what Git declares

```bash
kubectl get deploy gitops-app -n kcna-lab -o jsonpath='{.spec.replicas}'
```

### 4. Introduce configuration drift with a manual out-of-band change

```bash
kubectl scale deploy gitops-app -n kcna-lab --replicas=7
```

### 5. Detect the drift by diffing the cluster against the repository

```bash
kubectl diff -f gitops-repo/manifests/deployment.yaml || true
```

### 6. Run the reconciliation loop and watch the drift be corrected

```bash
bash reconcile.sh
```

### 7. Confirm the cluster was returned to the declared state automatically

```bash
kubectl get deploy gitops-app -n kcna-lab -o jsonpath='{.spec.replicas}'
```

### 8. Change the desired state in Git and let reconciliation roll it out

```bash
cd gitops-repo && sed -i.bak 's/replicas: 3/replicas: 4/' manifests/deployment.yaml && git commit -am 'Scale to 4' && cd .. && bash reconcile.sh
```

### 9. Walk the CI/CD pipeline and identify which stage is CI and which is CD

```bash
cat pipeline.yaml
```

### 10. Conduct the system review against the SLOs and record the adaptations

```bash
column -s, -t slo-targets.csv && cat system-review-report.md
```

## Test it

After the manual scale to 7, the reconciliation loop restores the replica count declared in Git; after committing replicas: 4, the same loop rolls the change out — and your system-review-report.md lists at least three evidence-backed adaptations against the breached SLOs.

## Clean up

```bash
# Remove the objects this lab created (safe to skip if you have cluster room)
kubectl delete -f . --ignore-not-found 2>/dev/null || true
```

---

*Kubernetes Fundamentals for Beginners (C742) · Tertiary Infotech Academy Pte Ltd · v1.0*
