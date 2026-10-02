# Lab 4 — Control Pod Scheduling with Requests, Taints and Affinity

**Topic 1** · Kubernetes Fundamentals and Architecture  
**Objective:** Influence where the scheduler places a Pod using resource requests, node selectors, taints, tolerations and affinity.

## What you'll do

The learner works through the scheduler's filter-and-score decision: setting resource requests that make a Pod unschedulable, labelling nodes, applying taints and tolerations, and expressing node and Pod affinity rules.

**What you'll build:** A set of Pods demonstrating successful placement, a deliberate Pending Pod, and a toleration that restores scheduling

**Tools and objects used:** kube-scheduler, resource requests and limits, nodeSelector, taints and tolerations, node affinity, pod anti-affinity

## Files in this folder

| File | What it is |
|---|---|
| `pod-resources.yaml` | Pod with explicit CPU/memory requests and limits. |
| `pod-unschedulable.yaml` | Pod requesting more memory than any node has — stays Pending. |
| `pod-toleration.yaml` | Pod carrying the toleration for the tainted node. |
| `deployment-antiaffinity.yaml` | Deployment spreading replicas with pod anti-affinity. |

## Before you start

```bash
# a running cluster and the shared namespace
kubectl get nodes
kubectl get ns kcna-lab || kubectl apply -f ../lab-02-kubernetes-api/namespace.yaml
cd labs/lab-04-control-pod-scheduling-with-requests
```

## Step-by-step

### 1. Inspect what capacity the node advertises and what is already requested

```bash
kubectl describe node minikube | grep -A8 'Allocated resources'
```

### 2. Deploy a Pod with explicit requests and limits and confirm placement

```bash
kubectl apply -f pod-resources.yaml && kubectl get pod resources-demo -n kcna-lab -o wide
```

### 3. Deploy a Pod that requests more memory than the node has

```bash
kubectl apply -f pod-unschedulable.yaml
```

### 4. Read the scheduler's own explanation of why the Pod is Pending

```bash
kubectl describe pod unschedulable-demo -n kcna-lab | grep -A5 Events
```

### 5. Label the node so a Pod can target it with a nodeSelector

```bash
kubectl label node minikube disktype=ssd --overwrite
```

### 6. Taint the node so that only tolerating Pods may be scheduled onto it

```bash
kubectl taint node minikube workload=restricted:NoSchedule --overwrite
```

### 7. Deploy a Pod carrying the matching toleration and confirm it schedules

```bash
kubectl apply -f pod-toleration.yaml && kubectl get pod toleration-demo -n kcna-lab -o wide
```

### 8. Deploy a Deployment using pod anti-affinity to spread replicas apart

```bash
kubectl apply -f deployment-antiaffinity.yaml
```

### 9. Observe how anti-affinity affects placement on a single-node cluster

```bash
kubectl get pods -n kcna-lab -l app=spread -o wide
```

### 10. Remove the taint to restore normal scheduling before the next lab

```bash
kubectl taint node minikube workload=restricted:NoSchedule-
```

## Test it

unschedulable-demo stays Pending with a FailedScheduling event naming Insufficient memory, while toleration-demo schedules successfully onto the tainted node — proving the filter stage of the scheduler.

## Clean up

```bash
# Remove the objects this lab created (safe to skip if you have cluster room)
kubectl delete -f . --ignore-not-found 2>/dev/null || true
```

---

*Kubernetes Fundamentals for Beginners (C742) · Tertiary Infotech Academy Pte Ltd · v1.0*
