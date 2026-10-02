# Lab 7 — Secure the Cluster with RBAC, Secrets and NetworkPolicy

**Topic 2** · Container Orchestration and Kubernetes Operations  
**Objective:** Apply the 4C security model using RBAC, ServiceAccounts, Secrets and network segmentation.

## What you'll do

The learner creates a least-privilege ServiceAccount bound to a namespaced Role, verifies the permission boundary with kubectl auth can-i, mounts credentials from a Secret, and switches the namespace to default-deny with a NetworkPolicy.

**What you'll build:** A least-privilege ServiceAccount, a mounted Secret, and a default-deny network posture with one allowed path

**Tools and objects used:** RBAC (Role, RoleBinding), ServiceAccount, Secret, NetworkPolicy, Pod Security Standards

## Files in this folder

| File | What it is |
|---|---|
| `serviceaccount.yaml` | The inventory-reader ServiceAccount. |
| `role-rbac.yaml` | Role + RoleBinding granting read-only access to Pods. |
| `secret-dbcreds.yaml` | Mock database credentials as a Secret. |
| `pod-secret-consumer.yaml` | Pod mounting the Secret as environment variables. |
| `networkpolicy-default-deny.yaml` | Default-deny ingress policy for the namespace. |
| `networkpolicy-allow-frontend.yaml` | Policy allowing only the frontend to reach the API. |

## Before you start

```bash
# a running cluster and the shared namespace
kubectl get nodes
kubectl get ns kcna-lab || kubectl apply -f ../lab-02-kubernetes-api/namespace.yaml
cd labs/lab-07-secure-the-cluster-with-rbac
```

## Step-by-step

### 1. Create a dedicated ServiceAccount for the application

```bash
kubectl apply -f serviceaccount.yaml
```

### 2. Bind a namespaced read-only Role to that ServiceAccount

```bash
kubectl apply -f role-rbac.yaml
```

### 3. Verify the permission it was granted

```bash
kubectl auth can-i list pods -n kcna-lab --as=system:serviceaccount:kcna-lab:inventory-reader
```

### 4. Verify the permission it was deliberately NOT granted

```bash
kubectl auth can-i delete pods -n kcna-lab --as=system:serviceaccount:kcna-lab:inventory-reader
```

### 5. Confirm the boundary is namespaced, not cluster-wide

```bash
kubectl auth can-i list pods -n kube-system --as=system:serviceaccount:kcna-lab:inventory-reader
```

### 6. Create the mock database credentials as a Secret

```bash
kubectl apply -f secret-dbcreds.yaml
```

### 7. Show that a Secret is base64-encoded, not encrypted at rest by default

```bash
kubectl get secret db-credentials -n kcna-lab -o jsonpath='{.data.password}' | base64 -d
```

### 8. Run a Pod that consumes the Secret as environment variables

```bash
kubectl apply -f pod-secret-consumer.yaml && kubectl logs secret-consumer -n kcna-lab
```

### 9. Apply a default-deny NetworkPolicy and confirm traffic is now blocked

```bash
kubectl apply -f networkpolicy-default-deny.yaml
```

### 10. Allow only the frontend to reach the API, then re-test connectivity

```bash
kubectl apply -f networkpolicy-allow-frontend.yaml
```

## Test it

auth can-i returns yes for list pods and no for delete pods and for kube-system; after the default-deny policy an unlabelled Pod cannot reach the inventory Service, while a Pod labelled app=frontend can.

## Clean up

```bash
# Remove the objects this lab created (safe to skip if you have cluster room)
kubectl delete -f . --ignore-not-found 2>/dev/null || true
```

---

*Kubernetes Fundamentals for Beginners (C742) · Tertiary Infotech Academy Pte Ltd · v1.0*
