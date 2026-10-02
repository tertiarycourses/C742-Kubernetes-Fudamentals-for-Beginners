# Kubernetes Fundamentals for Beginners

Go from zero to deploying, scaling, observing and operating containerised applications on Kubernetes — in two hands-on days with 16 labs on a local cluster you build yourself.

| Course detail | Information |
|---|---|
| Course code | `C742` |
| Programme | Non-WSQ |
| Duration | 2 days · 15 hours (9:30am – 5:30pm) |
| Course fee | S$700 (before GST) |
| Level | Beginner |
| Registration | [View course details and register](https://www.tertiarycourses.com.sg/kubernetes-fundamentals-for-beginners.html) |

**[📝 Register for Kubernetes Fundamentals for Beginners →](https://www.tertiarycourses.com.sg/kubernetes-fundamentals-for-beginners.html)**

---

## About the course

Kubernetes has become a key technology for deploying, managing and scaling containerised applications across modern IT environments. This course provides a practical introduction to Kubernetes, helping learners understand how containerised applications are orchestrated and managed.

You will work with clusters, nodes, Pods, Deployments, Services, namespaces and the Kubernetes architecture; explore networking, service discovery, storage, configuration and basic security; and practise autoscaling, monitoring, rolling updates and GitOps-style delivery. The five topics follow the five CNCF Kubernetes and Cloud Native Associate (KCNA) domains and their weightings, so the course is also a solid foundation for the KCNA certification.

Designed for beginners, IT professionals, system administrators, developers and aspiring DevOps engineers. No prior Kubernetes experience is assumed; basic familiarity with the Linux command line helps.

## Learning outcomes

On completion of this course, learners will be able to:

1. Develop an architectural proof of concept for Kubernetes architecture and components.
2. Develop solution architecture by applying container orchestration tools, techniques and system modelling methods.
3. Identify technical requirements and prepare a technical blueprint for Cloud Native Architecture.
4. Demonstrate how Cloud Native Observability solutions and components address a specific business problem effectively.
5. Implement system reviews to monitor solution status and adapt according to Cloud Native frameworks.

## Topics covered

| Topic | Labs |
|---|---|
| **1 · Kubernetes Fundamentals and Architecture** — resources, architecture, the API, containers, scheduling | 1–4 |
| **2 · Container Orchestration and Kubernetes Operations** — runtime, security, networking, service mesh, storage | 5–8 |
| **3 · Cloud Native Architecture and Scalability** — autoscaling, serverless, governance, open standards | 9–11 |
| **4 · Kubernetes Monitoring and Observability** — telemetry, Prometheus, cost management | 12–13 |
| **5 · Kubernetes Application Deployment and Management** — application delivery, GitOps, CI/CD | 14–16 |

## Labs

Each lab lives in its own folder under [`labs/`](labs/) with the YAML manifests, mock data and helper scripts it needs. Run them in order — later labs reuse objects created earlier.

| Lab | Title |
|---|---|
| 1 | [Bootstrap a Kubernetes Cluster and Explore the Architecture](labs/lab-01-bootstrap-a-kubernetes-cluster-and/) |
| 2 | [Work with the Kubernetes API and kubectl](labs/lab-02-work-with-the-kubernetes-api/) |
| 3 | [Deploy and Manage Pods, ReplicaSets and Deployments](labs/lab-03-deploy-and-manage-pods-replicasets/) |
| 4 | [Control Pod Scheduling with Requests, Taints and Affinity](labs/lab-04-control-pod-scheduling-with-requests/) |
| 5 | [Build and Run Containers with Docker and the OCI Standard](labs/lab-05-build-and-run-containers-with/) |
| 6 | [Expose Applications with Services and Ingress](labs/lab-06-expose-applications-with-services-and/) |
| 7 | [Secure the Cluster with RBAC, Secrets and NetworkPolicy](labs/lab-07-secure-the-cluster-with-rbac/) |
| 8 | [Persist Data with PersistentVolumes, StatefulSets and Storage Classes](labs/lab-08-persist-data-with-persistentvolumes-statefulsets/) |
| 9 | [Autoscale Workloads with the Horizontal Pod Autoscaler](labs/lab-09-autoscale-workloads-with-the-horizontal/) |
| 10 | [Build Resilience with Probes, Disruption Budgets and Multi-Tier Architecture](labs/lab-10-build-resilience-with-probes-disruption/) |
| 11 | [Explore Serverless, Open Standards and the CNCF Landscape](labs/lab-11-explore-serverless-open-standards-and/) |
| 12 | [Instrument and Collect Metrics with Prometheus](labs/lab-12-instrument-and-collect-metrics-with/) |
| 13 | [Apply the Golden Signals, Alerting and Cost Management](labs/lab-13-apply-the-golden-signals-alerting/) |
| 14 | [Perform Zero-Downtime Rolling Updates and Canary Releases](labs/lab-14-perform-zero-downtime-rolling-updates/) |
| 15 | [Package Applications with Helm and Kustomize](labs/lab-15-package-applications-with-helm-and/) |
| 16 | [Automate Delivery with GitOps and CI/CD, and Conduct a System Review](labs/lab-16-automate-delivery-with-gitops-and/) |

## Courseware

| Item | Files |
|---|---|
| Slide deck | [PPTX](courseware/Kubernetes%20Fundamentals%20for%20Beginners-v1.0.pptx) · [PDF](courseware/Kubernetes%20Fundamentals%20for%20Beginners-v1.0.pdf) |
| Lesson Plan | [DOCX](courseware/LP-Kubernetes%20Fundamentals%20for%20Beginners.docx) · [PDF](courseware/LP-Kubernetes%20Fundamentals%20for%20Beginners.pdf) |
| Learner Guide | [DOCX](courseware/LG-Kubernetes%20Fundamentals%20for%20Beginners.docx) · [PDF](courseware/LG-Kubernetes%20Fundamentals%20for%20Beginners.pdf) · [Markdown](LG-Kubernetes%20Fundamentals%20for%20Beginners.md) |
| Labs | [`labs/`](labs/) — 16 labs |

## Tools

| Tool | Used for |
|---|---|
| [Docker Desktop](https://www.docker.com/products/docker-desktop/) | Building the container images in Topic 2 |
| [minikube](https://minikube.sigs.k8s.io/) | The local single-node cluster used by every lab |
| [kubectl](https://kubernetes.io/docs/reference/kubectl/) | The command-line client for the Kubernetes API |
| [Helm 3](https://helm.sh/) | Packaging and releasing applications in Topic 5 |
| [Prometheus](https://prometheus.io/) | Metrics collection and PromQL in Topic 4 |
| [VS Code](https://code.visualstudio.com/) | Editing manifests (YAML + Kubernetes extensions) |

Hardware: a Windows or Mac laptop with at least 8 GB RAM and virtualisation enabled.

## Distribution

This repository publishes the learner-facing courseware (slides, Lesson Plan, Learner Guide and labs). It is provided for participants of the course; please do not redistribute the materials commercially.

## Contact

| | |
|---|---|
| Course page | [www.tertiarycourses.com.sg/kubernetes-fundamentals-for-beginners.html](https://www.tertiarycourses.com.sg/kubernetes-fundamentals-for-beginners.html) |
| Email | enquiry@tertiaryinfotech.com |
| Tel | +65 6100 0613 |
| LMS | [lms-tms.tertiaryinfotech.com](https://lms-tms.tertiaryinfotech.com) |

<sub>© 2026 Tertiary Infotech Academy Pte Ltd · UEN 201200696W</sub>
