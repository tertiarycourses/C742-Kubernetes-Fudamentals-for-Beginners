# Lab 6 — Expose Applications with Services and Ingress

**Topic 2** · Container Orchestration and Kubernetes Operations  
**Objective:** Apply Kubernetes networking to give stable discovery and external access to ephemeral Pods.

## What you'll do

The learner deploys the inventory API, fronts it with a ClusterIP Service, proves DNS-based service discovery from inside the cluster, then exposes it externally through NodePort and an Ingress with host-based routing.

**What you'll build:** An internally discoverable ClusterIP Service and an externally reachable Ingress route

**Tools and objects used:** Service (ClusterIP/NodePort/LoadBalancer), CoreDNS, Endpoints, Ingress, ingress-nginx, CNI

## Files in this folder

| File | What it is |
|---|---|
| `deployment-inventory.yaml` | Deployment of the inventory API built in Lab 5. |
| `service-clusterip.yaml` | ClusterIP Service selecting the inventory Pods. |
| `service-nodeport.yaml` | NodePort Service for external access. |
| `ingress-inventory.yaml` | Ingress with host-based routing for inventory.kcna.local. |

## Before you start

```bash
# a running cluster and the shared namespace
kubectl get nodes
kubectl get ns kcna-lab || kubectl apply -f ../lab-02-kubernetes-api/namespace.yaml
cd labs/lab-06-expose-applications-with-services-and
```

## Step-by-step

### 1. Deploy the inventory API into the cluster

```bash
kubectl apply -f deployment-inventory.yaml
```

### 2. Create a ClusterIP Service and inspect the virtual IP it receives

```bash
kubectl apply -f service-clusterip.yaml && kubectl get svc inventory -n kcna-lab
```

### 3. Confirm the Service selector actually matched Pods by reading its Endpoints

```bash
kubectl get endpoints inventory -n kcna-lab -o wide
```

### 4. Prove DNS service discovery from inside another Pod

```bash
kubectl run curl-test -n kcna-lab --rm -it --image=curlimages/curl --restart=Never -- curl -s http://inventory.kcna-lab.svc.cluster.local/inventory
```

### 5. Scale the Deployment and watch the Endpoints list grow automatically

```bash
kubectl scale deploy inventory -n kcna-lab --replicas=3 && kubectl get endpoints inventory -n kcna-lab
```

### 6. Expose the same Pods externally with a NodePort Service

```bash
kubectl apply -f service-nodeport.yaml
```

### 7. Reach the NodePort from outside the cluster

```bash
curl -s $(minikube ip):30080/inventory | head -10
```

### 8. Enable the ingress controller that will terminate HTTP routing

```bash
minikube addons enable ingress
```

### 9. Create the Ingress with host-based routing to the Service

```bash
kubectl apply -f ingress-inventory.yaml && kubectl get ingress -n kcna-lab
```

### 10. Test the host-based route through the ingress controller

```bash
curl -s -H 'Host: inventory.kcna.local' http://$(minikube ip)/inventory | head -10
```

## Test it

The curl-test Pod resolves inventory.kcna-lab.svc.cluster.local and returns inventory JSON, and the same data is returned through the Ingress using the Host header — proving discovery works internally and externally.

## Clean up

```bash
# Remove the objects this lab created (safe to skip if you have cluster room)
kubectl delete -f . --ignore-not-found 2>/dev/null || true
```

---

*Kubernetes Fundamentals for Beginners (C742) · Tertiary Infotech Academy Pte Ltd · v1.0*
