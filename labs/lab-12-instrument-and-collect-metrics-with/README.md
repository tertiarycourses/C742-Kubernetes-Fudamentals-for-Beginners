# Lab 12 — Instrument and Collect Metrics with Prometheus

**Topic 4** · Kubernetes Monitoring and Observability  
**Objective:** Demonstrate how observability components collect the telemetry needed to address a business problem.

## What you'll do

The learner deploys Prometheus into the cluster, exposes an application /metrics endpoint carrying mock order and latency data, confirms the scrape targets are healthy, and queries the data with PromQL to answer a stated business question.

**What you'll build:** A running Prometheus scraping a custom application exporter, queried with PromQL

**Tools and objects used:** Prometheus, exporters, /metrics endpoint, PromQL, ServiceMonitor concepts, counters/gauges/histograms

## Files in this folder

| File | What it is |
|---|---|
| `prometheus-config.yaml` | ConfigMap with the Prometheus scrape configuration. |
| `prometheus-deployment.yaml` | Prometheus Deployment + Service. |
| `prometheus-rbac.yaml` | ServiceAccount and ClusterRole for service discovery. |
| `metrics-app.yaml` | Sample app exposing counters, gauges and histograms. |
| `sample-metrics.txt` | Mock /metrics output — orders, errors and latency buckets. |

## Before you start

```bash
# a running cluster and the shared namespace
kubectl get nodes
kubectl get ns kcna-lab || kubectl apply -f ../lab-02-kubernetes-api/namespace.yaml
cd labs/lab-12-instrument-and-collect-metrics-with
```

## Step-by-step

### 1. Review the mock metrics payload and identify each metric type

```bash
head -25 sample-metrics.txt
```

### 2. Grant Prometheus the RBAC it needs for Kubernetes service discovery

```bash
kubectl apply -f prometheus-rbac.yaml
```

### 3. Load the Prometheus scrape configuration

```bash
kubectl apply -f prometheus-config.yaml
```

### 4. Deploy Prometheus itself

```bash
kubectl apply -f prometheus-deployment.yaml
```

### 5. Deploy the instrumented application exposing /metrics

```bash
kubectl apply -f metrics-app.yaml
```

### 6. Confirm the application is exposing metrics in the Prometheus text format

```bash
kubectl exec -n kcna-lab deploy/metrics-app -- wget -qO- localhost:8080/metrics | head -15
```

### 7. Port-forward the Prometheus UI to your workstation

```bash
kubectl port-forward -n kcna-lab svc/prometheus 9090:9090 &
```

### 8. Verify every scrape target is UP before trusting the data

```bash
curl -s 'http://localhost:9090/api/v1/targets' | python3 -c "import json,sys; [print(t['labels'].get('job'), t['health']) for t in json.load(sys.stdin)['data']['activeTargets']]"
```

### 9. Query per-second order throughput with rate() over the counter

```bash
curl -s --data-urlencode 'query=rate(orders_total[5m])' http://localhost:9090/api/v1/query
```

### 10. Compute the 95th-percentile latency from the histogram buckets

```bash
curl -s --data-urlencode 'query=histogram_quantile(0.95, rate(request_duration_seconds_bucket[5m]))' http://localhost:9090/api/v1/query
```

## Test it

The Prometheus targets API reports health=up for every job, and the PromQL queries return numeric values for order throughput and 95th-percentile latency.

## Clean up

```bash
# Remove the objects this lab created (safe to skip if you have cluster room)
kubectl delete -f . --ignore-not-found 2>/dev/null || true
```

---

*Kubernetes Fundamentals for Beginners (C742) · Tertiary Infotech Academy Pte Ltd · v1.0*
