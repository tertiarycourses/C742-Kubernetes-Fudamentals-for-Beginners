# Lab 1 — Bootstrap a Kubernetes Cluster and Explore the Architecture

**Topic 1** · Kubernetes Fundamentals and Architecture  
**Objective:** Explain the Kubernetes control-plane and node components and verify each one in a running cluster.

## What you'll do

The learner starts a local Kubernetes cluster with minikube, inspects every control-plane and node component, and maps what they observe onto the reference architecture diagram used in the proof of concept.

**What you'll build:** A running single-node Kubernetes cluster plus an annotated architecture inventory of its components

**Tools and objects used:** minikube, kubectl, kube-apiserver, etcd, kube-scheduler, kube-controller-manager, kubelet, kube-proxy

## Files in this folder

| File | What it is |
|---|---|
| `architecture-inventory.md` | Worksheet: record each component, where it runs and what it does. |
| `cluster-info.sh` | Helper script that dumps the component inventory in one pass. |

## Before you start

```bash
# a running cluster and the shared namespace
kubectl get nodes
kubectl get ns kcna-lab || kubectl apply -f ../lab-02-kubernetes-api/namespace.yaml
cd labs/lab-01-bootstrap-a-kubernetes-cluster-and
```

## Step-by-step

### 1. Confirm the tooling is installed and check the client version

```bash
kubectl version --client && minikube version
```

### 2. Start a single-node cluster with a known Kubernetes version

```bash
minikube start --nodes=1 --cpus=2 --memory=4096 --kubernetes-version=v1.31.0
```

### 3. Verify the node is Ready and inspect its capacity and conditions

```bash
kubectl get nodes -o wide && kubectl describe node minikube | head -40
```

### 4. List the control-plane components — they run as static Pods in kube-system

```bash
kubectl get pods -n kube-system -o wide
```

### 5. Confirm the API server is the single front door and check cluster health

```bash
kubectl cluster-info && kubectl get --raw='/readyz?verbose' | head -20
```

### 6. Inspect the etcd static Pod manifest to see how the datastore is configured

```bash
kubectl -n kube-system describe pod -l component=etcd | head -30
```

### 7. Watch the scheduler and controller-manager leader election in the logs

```bash
kubectl -n kube-system logs -l component=kube-scheduler --tail=20
```

### 8. Inspect kubelet on the node — the agent that actually starts containers

```bash
minikube ssh -- 'sudo systemctl status kubelet --no-pager | head -15'
```

### 9. List every API resource the cluster serves, grouped by API group

```bash
kubectl api-resources --sort-by=name | head -40
```

### 10. Complete architecture-inventory.md, recording each component and its role

```bash
bash cluster-info.sh > my-cluster-inventory.txt
```

## Test it

kubectl get nodes shows STATUS=Ready, kubectl get pods -n kube-system shows kube-apiserver, etcd, kube-scheduler, kube-controller-manager and kube-proxy all Running, and your architecture-inventory.md names the role of each.

## Clean up

```bash
# Remove the objects this lab created (safe to skip if you have cluster room)
kubectl delete -f . --ignore-not-found 2>/dev/null || true
```

---

*Kubernetes Fundamentals for Beginners (C742) · Tertiary Infotech Academy Pte Ltd · v1.0*
