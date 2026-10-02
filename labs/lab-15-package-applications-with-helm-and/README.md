# Lab 15 — Package Applications with Helm and Kustomize

**Topic 5** · Kubernetes Application Deployment and Management  
**Objective:** Package and parameterise a solution so it can be delivered repeatably across environments.

## What you'll do

The learner packages the application as a Helm chart with environment-specific values, installs and upgrades it, then achieves the same result with Kustomize overlays and compares the two approaches for the delivery blueprint.

**What you'll build:** An installed and upgraded Helm release plus equivalent dev and prod Kustomize overlays

**Tools and objects used:** Helm (chart, values, release, upgrade, rollback), Kustomize (base, overlays, patches), kubectl apply -k

## Files in this folder

| File | What it is |
|---|---|
| `helm-chart/Chart.yaml` | Helm chart metadata. |
| `helm-chart/values.yaml` | Default values — replicas, image, resources. |
| `helm-chart/values-prod.yaml` | Production overrides — 5 replicas, higher limits. |
| `helm-chart/templates/deployment.yaml` | Templated Deployment. |
| `helm-chart/templates/service.yaml` | Templated Service. |
| `kustomize/base/kustomization.yaml` | Kustomize base. |
| `kustomize/overlays/dev/kustomization.yaml` | Dev overlay — 1 replica. |
| `kustomize/overlays/prod/kustomization.yaml` | Prod overlay — 5 replicas + patch. |

## Before you start

```bash
# a running cluster and the shared namespace
kubectl get nodes
kubectl get ns kcna-lab || kubectl apply -f ../lab-02-kubernetes-api/namespace.yaml
cd labs/lab-15-package-applications-with-helm-and
```

## Step-by-step

### 1. Review the chart structure and where values are substituted

```bash
helm lint ./helm-chart && cat helm-chart/values.yaml
```

### 2. Render the templates locally to see the generated manifests

```bash
helm template webapp ./helm-chart | head -40
```

### 3. Install the chart as a release in the cluster

```bash
helm install webapp ./helm-chart --namespace kcna-lab
```

### 4. Confirm the release and the resources it created

```bash
helm list -n kcna-lab && kubectl get all -n kcna-lab -l app.kubernetes.io/instance=webapp
```

### 5. Upgrade the release with the production values file

```bash
helm upgrade webapp ./helm-chart -f helm-chart/values-prod.yaml -n kcna-lab
```

### 6. Verify the upgrade took effect and review the release history

```bash
kubectl get deploy -n kcna-lab -l app.kubernetes.io/instance=webapp && helm history webapp -n kcna-lab
```

### 7. Roll the release back to revision 1

```bash
helm rollback webapp 1 -n kcna-lab
```

### 8. Build the dev overlay with Kustomize and inspect the output

```bash
kubectl kustomize kustomize/overlays/dev | head -30
```

### 9. Apply the prod overlay and compare it with the dev result

```bash
kubectl apply -k kustomize/overlays/prod
```

### 10. Compare the two approaches and record which suits your blueprint

```bash
diff <(kubectl kustomize kustomize/overlays/dev) <(kubectl kustomize kustomize/overlays/prod) | head -20
```

## Test it

helm list shows the webapp release at revision 3 after the rollback, and the dev and prod Kustomize overlays render 1 and 5 replicas respectively from the same base.

## Clean up

```bash
# Remove the objects this lab created (safe to skip if you have cluster room)
kubectl delete -f . --ignore-not-found 2>/dev/null || true
```

---

*Kubernetes Fundamentals for Beginners (C742) · Tertiary Infotech Academy Pte Ltd · v1.0*
