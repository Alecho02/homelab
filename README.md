# Homelab

This repository documents a Raspberry Pi 5 homelab built as a small production-style platform for learning, portfolio work, and repeatable operations.

## Overview

The lab is organized as a layered system:

- `k3s` provides the Kubernetes foundation on Raspberry Pi hardware
- `Argo CD` keeps cluster state Git-driven and repeatable
- `Grafana` and `Prometheus` provide monitoring, dashboards, and alerting
- Cloudflare Tunnel publishes selected services without exposing the whole network
- NAS-backed storage holds persistent data, media, backups, and shared files
- `Pipita Store` runs as a separate application stack alongside the core platform

The goal is to show a real homelab with clear service boundaries, not just a demo screenshot.

## What Runs Here

### Cluster services

These are the services that live in the Kubernetes layer and support the platform itself:

- GitOps reconciliation with `Argo CD`
- Monitoring and alerting with `Prometheus`, `Grafana`, and exporters
- Ingress and proxying for services that need cluster-native exposure
- Supporting admin and utility workloads for day-to-day operations
- Application workloads deployed as manifests and kept in sync from Git

### NAS-backed services

The NAS is used as the durable storage and media layer:

- Persistent application data
- Shared files and app assets
- Media and content libraries
- Backups and restore-friendly snapshots
- Long-lived data that should not live only inside containers

### Public-facing workloads

Only selected services are published publicly:

- Reverse proxied web apps
- Controlled access endpoints
- Read-only or presentation-oriented services
- Portfolio-friendly surfaces that can be shown on LinkedIn without exposing internal details

### Supporting home services

The lab also carries the everyday services that make it useful at home:

- Media-related services and libraries
- Dashboards and admin tools
- Internal utility apps for day-to-day management
- Shared resources that support other workloads in the lab

### Application stack

`Pipita Store` is the main application stack represented in this repo:

- Docker Compose deployment for the app, database, and public proxy
- `PostgreSQL` for application data
- Local Nginx reverse proxy for controlled publication
- Environment-based configuration so secrets stay out of Git
- Media and assets stored locally instead of being committed

## How It Is Built

The homelab is implemented in layers so each responsibility stays separate:

1. Bring up the Raspberry Pi hosts and join them into a `k3s` cluster.
2. Install `Argo CD` and use it to reconcile the cluster from Git.
3. Deploy monitoring so health, capacity, and alerts are visible from day one.
4. Attach NAS storage for persistent data, app assets, and backup material.
5. Publish only the intended services through a reverse proxy or tunnel.
6. Keep application stacks isolated so one service does not define the whole lab.

## Representative Commands

The exact bootstrap flow is kept intentionally high-level here, but these are the kinds of commands used during bring-up:

```bash
# Check the cluster
kubectl get nodes
kubectl get pods -A

# Reconcile GitOps-managed apps
argocd app sync <app-name>
argocd app wait <app-name> --health --timeout 300

# Start the standalone app stack
docker compose up -d
docker compose logs -f

# Verify rollout and services
kubectl rollout status deploy/<deployment-name>
kubectl get svc -A
```

## Reverse Proxy and Exposure

Public services are not exposed directly from the app containers.

- Nginx receives the public request
- Static media and asset paths are served locally when appropriate
- Everything else is forwarded to the application process
- Cloudflare Tunnel is used where an extra exposure layer is needed
- Internal-only services stay private and are not published just because they exist

That gives the lab a cleaner public edge and keeps the network layout easy to reason about.

## Monitoring

Monitoring is part of the platform, not an afterthought.

- `Prometheus` collects metrics
- `Grafana` turns those metrics into dashboards
- Alerting components surface unhealthy services or missing signals
- Health checks and logs are used together to confirm the system is actually working

In practice, this means the homelab can be checked like a small production environment:

- cluster health
- app health
- storage health
- public exposure health
- backup confidence

## Security Posture

- No passwords, API tokens, or private keys are committed
- Local backups, workspace notes, and generated artifacts are ignored
- Public docs stay high-level and portfolio-friendly
- Admin and operational surfaces remain private unless explicitly exposed

## Notes For Reviewers

This homelab is meant to read like a maintained environment rather than a toy project:

- the stack is segmented
- exposure is intentional
- the docs are aligned with the actual deployment model
- the goal is to show practical DevOps and cloud engineering habits
