# Lab 11 — Open Standards Matrix

Open standards are what stop a cloud native blueprint becoming a lock-in decision.
Record the ACTUAL implementation found in your cluster — not the textbook answer.

| Standard | What it standardises | Why it matters to the blueprint | Implementation in YOUR cluster | Command used |
|---|---|---|---|---|
| OCI | Image and runtime format | An image built anywhere runs anywhere | | |
| CRI | Kubernetes ↔ container runtime | Swap containerd/CRI-O without changing Kubernetes | | |
| CNI | Pod networking plugin | Swap Calico/Cilium/Flannel without changing workloads | | |
| CSI | Storage plugin | The same PVC works on any storage backend | | |
| OpenTelemetry | Telemetry generation/export | Instrumentation survives a change of backend | | |
| SMI | Service mesh surface | A common surface across mesh implementations | | |

## Analysis

1. Which of these standards would you be most exposed to if you ignored it? Why?
2. Your organisation wants to move from on-premises to a managed cloud Kubernetes.
   Which standards make that portable, and what remains genuinely provider-specific?
3. Name one thing in your blueprint that is NOT covered by an open standard.
