# Lab 8 — Persist Data with PersistentVolumes, StatefulSets and Storage Classes

**Topic 2** · Container Orchestration and Kubernetes Operations  
**Objective:** Decouple storage from compute using PVCs, StorageClasses and StatefulSets, and model a service mesh's role.

## What you'll do

The learner provisions storage dynamically through a StorageClass, proves data survives Pod deletion, deploys a StatefulSet with per-replica volumes and stable identities, and compares this with the sidecar model used by a service mesh.

**What you'll build:** A dynamically provisioned PVC whose data survives Pod deletion, plus a 3-replica StatefulSet with stable storage

**Tools and objects used:** PersistentVolume, PersistentVolumeClaim, StorageClass, CSI, StatefulSet, headless Service, service mesh concepts

## Files in this folder

| File | What it is |
|---|---|
| `pvc-orders.yaml` | PersistentVolumeClaim requesting 1Gi of storage. |
| `pod-with-pvc.yaml` | Pod mounting the PVC and writing order records. |
| `statefulset-database.yaml` | 3-replica StatefulSet with volumeClaimTemplates. |
| `service-headless.yaml` | Headless Service giving each replica a stable DNS name. |
| `orders.csv` | Mock order records written to the volume. |

## Before you start

```bash
# a running cluster and the shared namespace
kubectl get nodes
kubectl get ns kcna-lab || kubectl apply -f ../lab-02-kubernetes-api/namespace.yaml
cd labs/lab-08-persist-data-with-persistentvolumes-statefulsets
```

## Step-by-step

### 1. Inspect the StorageClasses the cluster offers for dynamic provisioning

```bash
kubectl get storageclass
```

### 2. Request storage with a PersistentVolumeClaim

```bash
kubectl apply -f pvc-orders.yaml && kubectl get pvc -n kcna-lab
```

### 3. Confirm a PersistentVolume was provisioned automatically to satisfy it

```bash
kubectl get pv
```

### 4. Run a Pod that mounts the claim and writes the mock order records

```bash
kubectl apply -f pod-with-pvc.yaml
```

### 5. Verify the data was written to the persistent volume

```bash
kubectl exec -n kcna-lab writer -- cat /data/orders.csv | head -5
```

### 6. Delete the Pod — the volume and its data must survive

```bash
kubectl delete pod writer -n kcna-lab
```

### 7. Recreate the Pod and confirm the data is still there

```bash
kubectl apply -f pod-with-pvc.yaml && kubectl exec -n kcna-lab writer -- wc -l /data/orders.csv
```

### 8. Deploy a StatefulSet with a headless Service for stable identities

```bash
kubectl apply -f service-headless.yaml -f statefulset-database.yaml
```

### 9. Observe ordinal Pod names and the PVC created per replica

```bash
kubectl get pods,pvc -n kcna-lab -l app=database
```

### 10. Resolve a single replica by its stable DNS name

```bash
kubectl run dns-test -n kcna-lab --rm -it --image=busybox:1.36 --restart=Never -- nslookup database-0.database.kcna-lab.svc.cluster.local
```

## Test it

The order records survive deleting and recreating the Pod, and the StatefulSet produces database-0/1/2 each with its own PVC, with database-0 resolvable by its stable DNS name.

## Clean up

```bash
# Remove the objects this lab created (safe to skip if you have cluster room)
kubectl delete -f . --ignore-not-found 2>/dev/null || true
```

---

*Kubernetes Fundamentals for Beginners (C742) · Tertiary Infotech Academy Pte Ltd · v1.0*
