# Lab 9 — Autoscale Workloads with the Horizontal Pod Autoscaler

**Topic 3** · Cloud Native Architecture and Scalability  
**Objective:** Identify the technical requirements for elastic scaling and demonstrate autoscaling under real load.

## What you'll do

The learner enables the metrics pipeline, deploys a CPU-bound service with the resource requests the HPA needs, applies an HPA, generates load, and records the scale-up and scale-down behaviour as evidence for the blueprint.

**What you'll build:** A working HPA that scales a Deployment from 1 to 10 replicas under load and back down again

**Tools and objects used:** HorizontalPodAutoscaler, metrics-server, resource requests, Deployment, Cluster Autoscaler concepts

## Files in this folder

| File | What it is |
|---|---|
| `deployment-cpu-load.yaml` | CPU-bound PHP-Apache workload with CPU requests set. |
| `service-cpu-load.yaml` | Service fronting the CPU-bound workload. |
| `hpa-cpu.yaml` | HPA targeting 50% average CPU utilisation, 1-10 replicas. |
| `load-generator.yaml` | Pod generating continuous HTTP load. |
| `scaling-observations.md` | Worksheet: record replica counts against elapsed time. |

## Before you start

```bash
# a running cluster and the shared namespace
kubectl get nodes
kubectl get ns kcna-lab || kubectl apply -f ../lab-02-kubernetes-api/namespace.yaml
cd labs/lab-09-autoscale-workloads-with-the-horizontal
```

## Step-by-step

### 1. Enable the metrics pipeline the HPA reads from

```bash
minikube addons enable metrics-server
```

### 2. Confirm metrics are flowing before relying on them

```bash
kubectl top nodes && kubectl top pods -n kcna-lab
```

### 3. Deploy the CPU-bound workload — note the CPU request the HPA needs

```bash
kubectl apply -f deployment-cpu-load.yaml -f service-cpu-load.yaml
```

### 4. Create the HPA targeting 50% average CPU utilisation

```bash
kubectl apply -f hpa-cpu.yaml
```

### 5. Read the HPA's current view of the target metric

```bash
kubectl get hpa cpu-load -n kcna-lab -o wide
```

### 6. Start the load generator to drive CPU above the target

```bash
kubectl apply -f load-generator.yaml
```

### 7. Watch the HPA scale the Deployment up in response

```bash
kubectl get hpa cpu-load -n kcna-lab -w --timeout=300s
```

### 8. Record the scaling decisions the controller made and why

```bash
kubectl describe hpa cpu-load -n kcna-lab | grep -A10 Events
```

### 9. Remove the load and observe the stabilisation window before scale-down

```bash
kubectl delete -f load-generator.yaml
```

### 10. Complete scaling-observations.md with your replica-count timeline

```bash
kubectl get hpa cpu-load -n kcna-lab
```

## Test it

kubectl get hpa shows TARGETS rising well above 50% and REPLICAS increasing from 1 towards 10 under load, then returning to 1 after the 5-minute scale-down stabilisation window.

## Clean up

```bash
# Remove the objects this lab created (safe to skip if you have cluster room)
kubectl delete -f . --ignore-not-found 2>/dev/null || true
```

---

*Kubernetes Fundamentals for Beginners (C742) · Tertiary Infotech Academy Pte Ltd · v1.0*
