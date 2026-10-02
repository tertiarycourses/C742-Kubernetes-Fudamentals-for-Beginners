# Lab 10 — Technical Blueprint (LO3)

Complete this blueprint for the three-tier application you deployed. This is the
deliverable that evidences LO3: *identify technical requirements and prepare a
technical blueprint for Cloud Native Architecture*.

## 1. Components and their interfaces

| Tier | Kubernetes object | Replicas | Exposed as | Talks to |
|---|---|---|---|---|
| Frontend | Deployment + Service | 2 | ClusterIP :80 | api:8080 |
| API | Deployment + Service | 3 | ClusterIP :8080 | db:5432 |
| Database | Deployment + PVC + Service | 1 | ClusterIP :5432 | — |

## 2. Non-functional requirements

| Requirement | Target | How this design meets it | How you verified it |
|---|---|---|---|
| Availability during a Pod failure | No dropped requests | | |
| Availability during node maintenance | >= 2 API Pods up | | |
| Recovery from a hung container | Automatic restart | | |
| Data durability | Survives Pod restart | | |
| Resource fairness | No noisy neighbour | | |

## 3. Health-check design

| Tier | Startup probe | Liveness probe | Readiness probe | Rationale |
|---|---|---|---|---|
| Frontend | | | | |
| API | | | | |
| Database | | | | |

## 4. Trade-offs and decisions

1. Why does the database tier use `strategy: Recreate` rather than RollingUpdate?
2. Why is `minAvailable: 2` chosen for the API PDB rather than 1 or 3?
3. What breaks if the liveness probe is more aggressive than the startup probe allows?
4. What would you change to run this across three availability zones?
5. Which single change would most improve availability, and what would it cost?

## 5. Evidence

- [ ] `kubectl get deploy,svc,pvc,pdb -n kcna-lab` output attached
- [ ] Restart count increment after the deliberate health-check failure recorded
- [ ] `kubectl get pdb` ALLOWED DISRUPTIONS value recorded
