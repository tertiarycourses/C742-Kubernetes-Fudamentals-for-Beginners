# Lab 5 — Build and Run Containers with Docker and the OCI Standard

**Topic 2** · Container Orchestration and Kubernetes Operations  
**Objective:** Build an OCI image, run it as a container, and explain the runtime layer beneath Kubernetes.

## What you'll do

The learner containerises the sample inventory API, inspects the resulting OCI image layers, runs it locally with resource constraints, and then confirms which CRI runtime the Kubernetes cluster is actually using.

**What you'll build:** A tagged OCI image of the inventory API, running locally and loaded into the cluster

**Tools and objects used:** Docker, OCI image spec, containerd, CRI, crictl, image layers and registries

## Files in this folder

| File | What it is |
|---|---|
| `Dockerfile` | Multi-stage build for the inventory API. |
| `app.py` | Flask inventory API serving the mock inventory data. |
| `requirements.txt` | Python dependencies for the API. |
| `inventory.json` | Mock inventory data — 12 SKUs with stock levels. |

## Before you start

```bash
# a running cluster and the shared namespace
kubectl get nodes
kubectl get ns kcna-lab || kubectl apply -f ../lab-02-kubernetes-api/namespace.yaml
cd labs/lab-05-build-and-run-containers-with
```

## Step-by-step

### 1. Review the multi-stage Dockerfile and note why the runtime stage is slim

```bash
cat Dockerfile
```

### 2. Build the image and tag it with a version

```bash
docker build -t inventory-api:1.0 .
```

### 3. Inspect the image layers created by each Dockerfile instruction

```bash
docker history inventory-api:1.0
```

### 4. Read the OCI image configuration — entrypoint, env and architecture

```bash
docker inspect inventory-api:1.0 --format '{{json .Config}}' | python3 -m json.tool | head -20
```

### 5. Run the container locally with a memory limit and a published port

```bash
docker run -d --name inv --memory=256m -p 8080:8080 inventory-api:1.0
```

### 6. Call the API and confirm the mock inventory data is served

```bash
curl -s http://localhost:8080/inventory | head -20
```

### 7. Show that the container is just an isolated process on the host

```bash
docker top inv && docker stats --no-stream inv
```

### 8. Stop and remove the local container

```bash
docker rm -f inv
```

### 9. Load the image into the cluster so Kubernetes can run it without a registry

```bash
minikube image load inventory-api:1.0
```

### 10. Confirm which CRI runtime the node uses to run containers

```bash
kubectl get node minikube -o jsonpath='{.status.nodeInfo.containerRuntimeVersion}'
```

## Test it

curl http://localhost:8080/inventory returns the 12 mock SKUs, and the node's containerRuntimeVersion reports containerd (or cri-o), confirming Kubernetes runs OCI images through the CRI.

## Clean up

```bash
# Remove the objects this lab created (safe to skip if you have cluster room)
kubectl delete -f . --ignore-not-found 2>/dev/null || true
```

---

*Kubernetes Fundamentals for Beginners (C742) · Tertiary Infotech Academy Pte Ltd · v1.0*
