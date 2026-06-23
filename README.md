# Homelab Portfolio

This repository is a public-facing snapshot of the homelab as it exists today. It is written to read well in a portfolio or LinkedIn context while staying away from passwords, tokens, private hostnames, and other sensitive operational details.

## What Is In Scope

- `Pipita Store`, the public storefront
- The homelab service catalog that supports media, network, monitoring, and cluster access
- Sanitized manifests that describe how the internal portal is laid out
- Captures from live apps that show the system in use

## What Is Confirmed Here

From the files in this repo, the stack is organized around:

- `Pipita Store` running as a containerized app
- `PostgreSQL` for application persistence
- `Nginx` as the public reverse proxy for the storefront
- A k3s cluster split across a Raspberry Pi control-plane and a `qnas` worker
- `Cloudflare Tunnel` and `Traefik` for cluster exposure where appropriate
- A NAS layer with about 6 TB of RAID1 storage for media, backups, and shared data
- A broader homelab service catalog that covers media, DNS, observability, and cluster tools

## Current Homelab Stack

### Public Application

- `Pipita Store` - storefront application
- `PostgreSQL` - backing database
- `Nginx` - reverse proxy and static file edge

### NAS Media Platform

- `Jellyfin` - media server
- `Jellyseerr` - request workflow for movies and series
- `Radarr` - movie management
- `Sonarr` - series management
- `Bazarr` - subtitles
- `Prowlarr` - indexer management
- `FlareSolverr` - resolver for indexers
- `Jellystat` - Jellyfin statistics
- `qBittorrent` - downloads

### Network and DNS

- `Pi-hole` - DNS and ad blocking
- `Tailscale` - private mesh access for admin and remote reachability
- `Portainer` - container management on the NAS

### Observability

- `Grafana` - dashboards and metrics
- `Prometheus` - metrics collection and scraping
- `Alertmanager` - alert routing and status

### Cluster and Access

- `Homepage` - internal portal for the homelab
- `Headlamp` - Kubernetes visibility
- `pgAdmin` - PostgreSQL administration
- `Cloudflare Tunnel` - selected public exposure without broad inbound access
- `Traefik` - Kubernetes ingress and service exposure
- Router admin - local network management

## How It Was Implemented

The platform is split into a small public storefront and a larger homelab service layer:

1. The storefront runs as a containerized app stack.
2. `PostgreSQL` holds the persistent data.
3. `Nginx` publishes the storefront through a controlled public edge.
4. The Raspberry Pi hosts the k3s control-plane and most admin surfaces.
5. The NAS hosts the media automation stack, DNS helpers, and remote access tooling.
6. The NAS-side worker also hosts tunnel, ingress, and observability workloads.
7. Homepage keeps the internal catalog of services organized.
8. Screenshots and manifests stay sanitized so the repo can be shared publicly.

## Representative Commands

These are the kinds of commands used to bring the stack up and verify it:

```bash
docker compose up -d
docker compose logs -f
kubectl get nodes
kubectl get pods -A
kubectl get svc -A
kubectl get pvc -A
kubectl get ingress -A
kubectl apply -f manifests/homepage-services.example.yaml
```

## Reverse Proxy

The storefront is not exposed by the app container directly.

- The app stays behind `Nginx`
- `Nginx` serves the public edge and forwards requests to the app
- Static media and assets are handled separately
- `Cloudflare Tunnel` is used for selected cluster services
- `Traefik` handles Kubernetes ingress
- The database remains isolated from the public layer

That gives the project a cleaner operational shape and a more professional story for public sharing.

## Monitoring

The monitoring layer is built around:

- `Prometheus` for metrics collection and scraping
- `Grafana` for dashboards and visual analysis
- `Alertmanager` for alert routing and status

This is enough to explain how the platform is observed without exposing internal targets or sensitive endpoints.

The live apps and exporters feed Grafana with health and usage data for:

- database health
- media automation health
- public service availability
- ingress and tunnel status

## Public Files

- `docs/service-catalog.md`
- `docs/screenshots/README.md`
- `manifests/homepage-services.example.yaml`
- `docs/screenshots/jellyseerr-dashboard.jpg`
- `docs/screenshots/jellystat-analytics.jpg`

## Notes

- This repo does not describe a historical Argo CD setup.
- The README reflects the current documented stack instead of older versions.
- Anything that could leak credentials, private addresses, or internal-only operational detail stays out of the public tree.
