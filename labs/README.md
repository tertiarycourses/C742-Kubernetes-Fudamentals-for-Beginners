# Labs — Kubernetes Fundamentals for Beginners

16 hands-on labs across the five course topics. Each lab has its own
folder containing every YAML manifest, mock data file and helper script it needs.

Run the labs in order — later labs reuse the namespace and objects created earlier.

| Lab | Title | Topic | Folder |
|---|---|---|---|
| 1 | Bootstrap a Kubernetes Cluster and Explore the Architecture | 1 | `lab-01-bootstrap-a-kubernetes-cluster-and/` |
| 2 | Work with the Kubernetes API and kubectl | 1 | `lab-02-work-with-the-kubernetes-api/` |
| 3 | Deploy and Manage Pods, ReplicaSets and Deployments | 1 | `lab-03-deploy-and-manage-pods-replicasets/` |
| 4 | Control Pod Scheduling with Requests, Taints and Affinity | 1 | `lab-04-control-pod-scheduling-with-requests/` |
| 5 | Build and Run Containers with Docker and the OCI Standard | 2 | `lab-05-build-and-run-containers-with/` |
| 6 | Expose Applications with Services and Ingress | 2 | `lab-06-expose-applications-with-services-and/` |
| 7 | Secure the Cluster with RBAC, Secrets and NetworkPolicy | 2 | `lab-07-secure-the-cluster-with-rbac/` |
| 8 | Persist Data with PersistentVolumes, StatefulSets and Storage Classes | 2 | `lab-08-persist-data-with-persistentvolumes-statefulsets/` |
| 9 | Autoscale Workloads with the Horizontal Pod Autoscaler | 3 | `lab-09-autoscale-workloads-with-the-horizontal/` |
| 10 | Build Resilience with Probes, Disruption Budgets and Multi-Tier Architecture | 3 | `lab-10-build-resilience-with-probes-disruption/` |
| 11 | Explore Serverless, Open Standards and the CNCF Landscape | 3 | `lab-11-explore-serverless-open-standards-and/` |
| 12 | Instrument and Collect Metrics with Prometheus | 4 | `lab-12-instrument-and-collect-metrics-with/` |
| 13 | Apply the Golden Signals, Alerting and Cost Management | 4 | `lab-13-apply-the-golden-signals-alerting/` |
| 14 | Perform Zero-Downtime Rolling Updates and Canary Releases | 5 | `lab-14-perform-zero-downtime-rolling-updates/` |
| 15 | Package Applications with Helm and Kustomize | 5 | `lab-15-package-applications-with-helm-and/` |
| 16 | Automate Delivery with GitOps and CI/CD, and Conduct a System Review | 5 | `lab-16-automate-delivery-with-gitops-and/` |

## Environment

```bash
minikube start --nodes=1 --cpus=2 --memory=4096 --kubernetes-version=v1.31.0
kubectl apply -f lab-02-kubernetes-api/namespace.yaml
```

*Kubernetes Fundamentals for Beginners (C742) · Tertiary Infotech Academy Pte Ltd · v1.0*
