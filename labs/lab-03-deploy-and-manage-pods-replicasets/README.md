# Lab 3 — Deploy and Manage Pods, ReplicaSets and Deployments

**Topic 1** · Kubernetes Fundamentals and Architecture  
**Objective:** Build the core workload resources and explain how a Deployment manages ReplicaSets which manage Pods.

## What you'll do

The learner deploys the sample store-front application, scales it, breaks it deliberately to observe self-healing, then performs a rolling update and a rollback to see the Deployment/ReplicaSet/Pod ownership chain in action.

**What you'll build:** A 3-replica Deployment that survives Pod deletion, plus a completed rolling update and rollback

**Tools and objects used:** Deployment, ReplicaSet, Pod, kubectl scale, kubectl rollout, labels and selectors

## Files in this folder

| File | What it is |
|---|---|
| `deployment-storefront.yaml` | 3-replica Deployment of the sample store-front app. |
| `configmap-catalog.yaml` | Mock product catalogue (10 products) served by the app. |

## Before you start

```bash
# a running cluster and the shared namespace
kubectl get nodes
kubectl get ns kcna-lab || kubectl apply -f ../lab-02-kubernetes-api/namespace.yaml
cd labs/lab-03-deploy-and-manage-pods-replicasets
```

## Step-by-step

### 1. Load the mock product catalogue the application will serve

```bash
kubectl apply -f configmap-catalog.yaml
```

### 2. Deploy the store-front application with three replicas

```bash
kubectl apply -f deployment-storefront.yaml
```

### 3. Observe the ownership chain: Deployment owns ReplicaSet owns Pods

```bash
kubectl get deploy,rs,pods -n kcna-lab -l app=storefront
```

### 4. Confirm the ownerReferences that link a Pod back to its ReplicaSet

```bash
kubectl get pods -n kcna-lab -l app=storefront -o jsonpath='{.items[0].metadata.ownerReferences[0].kind}'
```

### 5. Delete a Pod and watch the ReplicaSet controller replace it (self-healing)

```bash
kubectl delete pod -n kcna-lab -l app=storefront --field-selector=status.phase=Running --wait=false
```

### 6. Scale the Deployment up and confirm the new replica count

```bash
kubectl scale deployment storefront -n kcna-lab --replicas=5
```

### 7. Perform a rolling update to a new image version

```bash
kubectl set image deployment/storefront storefront=nginx:1.27-alpine -n kcna-lab
```

### 8. Watch the rollout progress and see a second ReplicaSet appear

```bash
kubectl rollout status deployment/storefront -n kcna-lab && kubectl get rs -n kcna-lab
```

### 9. Review the revision history the Deployment keeps for you

```bash
kubectl rollout history deployment/storefront -n kcna-lab
```

### 10. Roll back to the previous revision and confirm the image reverted

```bash
kubectl rollout undo deployment/storefront -n kcna-lab
```

## Test it

After deleting a Pod the replica count returns to the desired number within seconds; after the rollback, kubectl describe deployment shows the original nginx:1.27 image and two ReplicaSets exist with only the original scaled up.

## Clean up

```bash
# Remove the objects this lab created (safe to skip if you have cluster room)
kubectl delete -f . --ignore-not-found 2>/dev/null || true
```

---

*Kubernetes Fundamentals for Beginners (C742) · Tertiary Infotech Academy Pte Ltd · v1.0*
