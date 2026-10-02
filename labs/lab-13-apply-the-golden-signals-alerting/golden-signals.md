# Lab 13 — The Four Golden Signals

For each signal write the PromQL against the metrics exposed by `metrics-app`, run it,
and record what you actually saw. This is the dashboard specification you would hand
to whoever operates the service.

## 1. Latency — how long requests take

- **Why it matters:** users experience latency directly.
- **Use the percentile, never the mean** — the mean hides the tail that hurts.

```promql
histogram_quantile(0.95, rate(request_duration_seconds_bucket[5m]))
```

Observed p95: ________   Observed p99: ________

## 2. Traffic — how much demand there is

```promql
rate(orders_total[5m])
```

Observed orders/sec: ________

## 3. Errors — the rate of failed requests

```promql
rate(errors_total[5m]) / rate(orders_total[5m])
```

Observed error ratio: ________

## 4. Saturation — how full the system is

```promql
queue_depth
```

Observed queue depth: ________

## Analysis

1. Why must a counter always be wrapped in `rate()` before it is graphed or alerted on?
2. Why does `HighErrorRate` use `for: 1m` rather than firing immediately?
3. `PodRestarted_AntiPattern` in `alert-rules.yaml` is deliberately bad.
   Explain in one sentence why it would page someone for no good reason.
4. Which ONE of the four signals would you alert on first if you could only have one?
