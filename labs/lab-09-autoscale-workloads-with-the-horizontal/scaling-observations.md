# Lab 9 — Autoscaling Observations

Record what the HPA actually did. This is your evidence for the scalability section
of the technical blueprint (LO3).

## Configuration under test

| Setting | Value |
|---|---|
| CPU request per Pod | 200m |
| HPA target utilisation | 50% |
| minReplicas / maxReplicas | 1 / 10 |
| Scale-down stabilisation window | 300s |

## Observed behaviour

| Elapsed | TARGETS (current/target) | REPLICAS | What changed |
|---|---|---|---|
| t = 0 (before load) | | 1 | baseline |
| t = 1 min | | | load generator started |
| t = 2 min | | | |
| t = 5 min | | | |
| t = 8 min | | | load generator deleted |
| t = 13 min | | | after stabilisation window |

## Analysis

1. How long after the load started did the first scale-up happen? Why not instantly?
2. The HPA formula is `ceil(replicas x currentMetric / targetMetric)`.
   Work through one scaling decision by hand using your recorded numbers.
3. Why did scale-down take much longer than scale-up? Which setting controls this?
4. What would break if the Deployment had no CPU **request** set?
5. What would you set `averageUtilization` to for a latency-sensitive service, and why?
