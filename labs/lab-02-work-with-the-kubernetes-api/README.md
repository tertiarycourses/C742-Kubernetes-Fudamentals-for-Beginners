# Lab 2 — Work with the Kubernetes API and kubectl

**Topic 1** · Kubernetes Fundamentals and Architecture  
**Objective:** Use the declarative Kubernetes API to create, inspect and delete objects, and read the API directly.

## What you'll do

The learner drives the Kubernetes API through kubectl and through raw HTTP, comparing imperative and declarative object management, and reads the anatomy of an API object — apiVersion, kind, metadata, spec and status.

**What you'll build:** A namespace and Pod created declaratively, plus a raw API call transcript showing the same objects

**Tools and objects used:** kubectl, kube-apiserver, kubectl proxy, YAML manifests, API groups and versions

## Files in this folder

| File | What it is |
|---|---|
| `namespace.yaml` | The kcna-lab namespace used by every later lab. |
| `pod-nginx.yaml` | A minimal Pod manifest showing apiVersion/kind/metadata/spec. |

## Before you start

```bash
# a running cluster and the shared namespace
kubectl get nodes
kubectl get ns kcna-lab || kubectl apply -f ../lab-02-kubernetes-api/namespace.yaml
cd labs/lab-02-work-with-the-kubernetes-api
```

## Step-by-step

### 1. Read the anatomy of an object with explain, field by field

```bash
kubectl explain pod.spec.containers --recursive | head -30
```

### 2. Create the working namespace declaratively from the manifest

```bash
kubectl apply -f namespace.yaml
```

### 3. Create a Pod declaratively and watch it move through its phases

```bash
kubectl apply -f pod-nginx.yaml && kubectl get pod -n kcna-lab -w --timeout=60s
```

### 4. Read back the live object, including the status the controllers wrote

```bash
kubectl get pod nginx -n kcna-lab -o yaml | head -40
```

### 5. Compare the imperative equivalent, using --dry-run to see the generated object

```bash
kubectl run temp --image=nginx:1.27 --dry-run=client -o yaml
```

### 6. Open a local proxy to the API server and call the REST endpoint directly

```bash
kubectl proxy --port=8001 &
```

### 7. Query the same Pod over raw HTTP to prove kubectl is only an API client

```bash
curl -s http://127.0.0.1:8001/api/v1/namespaces/kcna-lab/pods/nginx | head -30
```

### 8. Inspect the API groups and versions the server exposes

```bash
curl -s http://127.0.0.1:8001/apis | head -30
```

### 9. Use a label selector and JSONPath to extract just the fields you need

```bash
kubectl get pods -n kcna-lab -l app=nginx -o jsonpath='{.items[*].status.podIP}'
```

### 10. Clean up the proxy process when you are finished

```bash
kill %1
```

## Test it

curl against /api/v1/namespaces/kcna-lab/pods/nginx returns the same object that kubectl get pod prints, confirming kubectl is only a client of the API server.

## Clean up

```bash
# Remove the objects this lab created (safe to skip if you have cluster room)
kubectl delete -f . --ignore-not-found 2>/dev/null || true
```

---

*Kubernetes Fundamentals for Beginners (C742) · Tertiary Infotech Academy Pte Ltd · v1.0*
