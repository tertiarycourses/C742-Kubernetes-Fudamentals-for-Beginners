# Lab 1 — Kubernetes Architecture Inventory

Complete this worksheet as you work through the lab. It becomes evidence for LO1
(an architectural proof of concept for Kubernetes architecture and components).

## Control plane — what decides

| Component | Where it runs | What it does | Command you used to verify it |
|---|---|---|---|
| kube-apiserver | | | |
| etcd | | | |
| kube-scheduler | | | |
| kube-controller-manager | | | |

## Worker node — what runs

| Component | Where it runs | What it does | Command you used to verify it |
|---|---|---|---|
| kubelet | | | |
| kube-proxy | | | |
| container runtime | | | |

## Questions to answer

1. Which single component does every other component talk to, and why does that matter?
2. What happens to the cluster if etcd is lost? What is your backup strategy?
3. How many control-plane nodes would you run in production, and why an odd number?
4. Which components run as static Pods, and who starts them?
