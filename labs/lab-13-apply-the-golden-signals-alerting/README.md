# Lab 13 — Apply the Golden Signals, Alerting and Cost Management

**Topic 4** · Kubernetes Monitoring and Observability  
**Objective:** Demonstrate how observability and cost data together resolve a specific business problem.

## What you'll do

The learner builds the four golden signals for the order service, writes an alerting rule that fires on the symptom rather than the cause, then analyses cost data — requests versus actual usage — and recommends right-sizing backed by evidence.

**What you'll build:** A golden-signals dashboard specification, a firing alert rule, and a costed right-sizing recommendation

**Tools and objects used:** Prometheus alerting rules, golden signals, kubectl top, resource requests, FinOps right-sizing

## Files in this folder

| File | What it is |
|---|---|
| `alert-rules.yaml` | Alerting rules for error rate, latency and saturation. |
| `golden-signals.md` | Worksheet: the PromQL query for each golden signal. |
| `cost-report.csv` | Mock cost report — 6 namespaces, requested vs used vs monthly cost. |
| `error-burst.yaml` | Job generating an error burst to make the alert fire. |
| `rightsizing-analysis.md` | Worksheet for the costed recommendation. |

## Before you start

```bash
# a running cluster and the shared namespace
kubectl get nodes
kubectl get ns kcna-lab || kubectl apply -f ../lab-02-kubernetes-api/namespace.yaml
cd labs/lab-13-apply-the-golden-signals-alerting
```

## Step-by-step

### 1. Write the PromQL for each golden signal into golden-signals.md

```bash
cat golden-signals.md
```

### 2. Load the alerting rules into Prometheus

```bash
kubectl apply -f alert-rules.yaml
```

### 3. Reload the Prometheus configuration so the rules take effect

```bash
kubectl rollout restart deploy/prometheus -n kcna-lab
```

### 4. Confirm the rules were loaded and are evaluating

```bash
curl -s http://localhost:9090/api/v1/rules | python3 -m json.tool | head -25
```

### 5. Generate an error burst so the symptom-based alert fires

```bash
kubectl apply -f error-burst.yaml
```

### 6. Watch the alert transition from Pending to Firing

```bash
curl -s http://localhost:9090/api/v1/alerts | python3 -m json.tool | head -25
```

### 7. Compare requested resources against what the Pods actually use

```bash
kubectl top pods -n kcna-lab --sort-by=cpu
```

### 8. Read the mock cost report and identify the two worst-value namespaces

```bash
column -s, -t cost-report.csv
```

### 9. Calculate the waste from over-requested CPU and memory

```bash
python3 -c "import csv;r=list(csv.DictReader(open('cost-report.csv')));[print(x['namespace'], round(1-float(x['cpu_used'])/float(x['cpu_requested']),2)) for x in r]"
```

### 10. Record your costed right-sizing recommendation with the evidence

```bash
cat rightsizing-analysis.md
```

## Test it

The HighErrorRate alert reaches state=firing in the Prometheus alerts API after the error burst, and your rightsizing-analysis.md names the two most over-provisioned namespaces with the monthly saving each change would deliver.

## Clean up

```bash
# Remove the objects this lab created (safe to skip if you have cluster room)
kubectl delete -f . --ignore-not-found 2>/dev/null || true
```

---

*Kubernetes Fundamentals for Beginners (C742) · Tertiary Infotech Academy Pte Ltd · v1.0*
