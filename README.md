# Homelab

This repository documents a Raspberry Pi 5 homelab built as a small production-style platform for learning, portfolio work, and repeatable operations.

## What This Lab Contains

The homelab is organized in layers so each responsibility stays separate:

- `k3s` provides the Kubernetes base on Raspberry Pi hardware
- `Argo CD` keeps cluster state Git-driven and repeatable
- `Grafana` and `Prometheus` provide dashboards, metrics, and alerting
- Cloudflare Tunnel publishes selected services without exposing the whole network
- NAS-backed storage holds persistent data, media, backups, and shared files
- `Pipita Store` runs as a separate application stack alongside the core platform

The goal is to show a real, maintained homelab with clear service boundaries instead of a demo snapshot.

## Current Service Inventory

### Internet

- `Pipita Store` - public storefront
- `Jellyfin` - media server
- `Jellyseerr` - movie and series requests
- `Grafana` - public dashboard access for the lab

### Media and Downloads

- `Jellyfin` - media server
- `Jellyseerr` - request workflow for movies and series
- `Radarr` - movie management
- `Sonarr` - series management
- `Bazarr` - subtitles
- `Prowlarr` - indexer management
- `FlareSolverr` - resolver for indexers
- `Jellystat` - Jellyfin usage statistics
- `qBittorrent` - downloads

### Network and DNS

- `Pi-hole` - DNS and ad blocking
- `Portainer` - container management on the NAS

### Observability

- `Grafana` - dashboards and metrics
- `Prometheus` - metrics collection and target scraping
- `Alertmanager` - alert routing and status

### Cluster

- `Headlamp` - Kubernetes visibility
- `pgAdmin` - PostgreSQL administration
- `Homepage` - main internal portal for the homelab
- Router admin - local network management

### Supporting home services

- Media-related services and libraries
- Dashboards and admin tools
- Internal utility apps for day-to-day management
- Shared resources that support other workloads in the lab

## How It Is Built

The environment was assembled in layers so the platform stays understandable and recoverable:

1. Bring up the Raspberry Pi hosts and join them into `k3s`.
2. Install `Argo CD` and let Git reconcile the desired state.
3. Deploy monitoring early so health, capacity, and alerts are visible.
4. Attach NAS storage for persistent data, app assets, and backups.
5. Publish only intended services through a reverse proxy or tunnel.
6. Keep application stacks isolated so one service does not define the whole lab.

## How It Is Operated

Representative commands used during day-to-day maintenance:

```bash
# Cluster visibility
kubectl get nodes
kubectl get pods -A

# GitOps sync
argocd app sync <app-name>
argocd app wait <app-name> --health --timeout 300

# Standalone app stack
docker compose up -d
docker compose logs -f

# Rollout and service checks
kubectl rollout status deploy/<deployment-name>
kubectl get svc -A
```

## Reverse Proxy and Public Exposure

Public services are not exposed directly from app containers.

- Nginx receives the public request
- Static media and asset paths are served locally when appropriate
- Everything else is forwarded to the application process
- Cloudflare Tunnel is used where an extra exposure layer is needed
- Internal-only services stay private and are not published just because they exist

That keeps the public edge clean and the internal network easy to reason about.

## Monitoring

Monitoring is part of the platform, not an afterthought.

- `Prometheus` collects metrics
- `Grafana` turns those metrics into dashboards
- `Alertmanager` surfaces unhealthy services or missing signals
- Health checks and logs are used together to confirm the system is actually working

The result is a homelab that can be checked like a small production environment:

- cluster health
- app health
- storage health
- public exposure health
- backup confidence

## Public Manifests

The public repo includes sanitized manifests and service catalogs, not private secrets or tokens.

- `docs/service-catalog.md` lists the public service inventory
- `manifests/homepage-services.example.yaml` shows the Homepage layout without sensitive values
- `docs/screenshots/` is reserved for exported public screenshots
- `pipita-store/.env.example` documents required environment values without revealing real credentials

## Pipita Store

`Pipita Store` is the main application stack represented in this repository.

### Stack

- Docker Compose deployment for the app, database, and public proxy
- `PostgreSQL` for application data
- Local Nginx reverse proxy for controlled publication
- Environment-based configuration so secrets stay out of Git
- Media and assets stored locally instead of being committed

### Deployment Pattern

The app container stays on localhost, the proxy handles the public-facing edge, and the database persists on named storage. That gives the storefront a clean separation between application logic, storage, and exposure.

## Security Posture

- No passwords, API tokens, or private keys are committed
- Local backups, workspace notes, and generated artifacts are ignored
- Public docs stay high-level and portfolio-friendly
- Admin and operational surfaces remain private unless explicitly exposed

## Notes For Reviewers

This homelab is meant to read like a maintained environment rather than a toy project:

- the stack is segmented
- exposure is intentional
- the docs match the actual deployment model
- the goal is to show practical DevOps and cloud engineering habits
