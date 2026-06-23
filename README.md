# Homelab Portfolio 🛠️

This repository is a public-facing snapshot of a real homelab built to read well in a DevOps, Cloud, and SRE portfolio. It shows how the platform was assembled, how the services are split across the cluster and the NAS, and how the whole thing is documented without leaking secrets.

## What This Repo Shows

- 🧱 A k3s cluster split across a Raspberry Pi control-plane and a `qnas` worker
- 💽 A NAS layer with about 6 TB of RAID1 storage for media, shared data, and supporting services
- 📺 A media automation ecosystem built around Jellyfin, Jellyseerr, Radarr, Sonarr, Bazarr, Prowlarr, FlareSolverr, Jellystat, and qBittorrent
- 🌐 Network and access services such as Pi-hole, Tailscale, Portainer, Traefik, Cloudflare Tunnel, and Nginx
- 📈 Observability with Prometheus, Grafana, and Alertmanager
- 🖥️ A public storefront stack with `Pipita Store`, `PostgreSQL`, and `Nginx`
- 🧩 Sanitized manifests and docs that explain the architecture without exposing credentials or private endpoints

## The Story

The repo is organized so the story reads from top to bottom:

1. Start with the public storefront and its simple app/database/proxy split.
2. Move into the cluster where the Raspberry Pi acts as the control-plane and the worker side hosts ingress, tunnels, and supporting workloads.
3. Layer in the NAS where the media automation chain lives and where Portainer helps keep containerized services manageable.
4. Add observability so Grafana can show real health and usage data from the platform.
5. Finish with Homepage manifests and screenshots that make the environment easy to present publicly.

If you want the implementation narrative in more detail, read [docs/implementation.md](docs/implementation.md).

## Current Stack

### Public Application

- `Pipita Store` - storefront application
- `PostgreSQL` - backing database
- `Nginx` - public edge and reverse proxy

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

### Network and Access

- `Pi-hole` - DNS and ad blocking
- `Tailscale` - private mesh access for admin and remote reachability
- `Portainer` - container management on the NAS

### Observability

- `Grafana` - dashboards and metrics
- `Prometheus` - metrics collection and scraping
- `Alertmanager` - alert routing and status

### Cluster and Exposure

- `Homepage` - internal portal for the homelab
- `Headlamp` - Kubernetes visibility
- `pgAdmin` - PostgreSQL administration
- `Cloudflare Tunnel` - selected public exposure without broad inbound access
- `Traefik` - Kubernetes ingress and service exposure

## How It Was Built

- The public app runs as a containerized stack with a clean reverse-proxy edge.
- The cluster keeps platform services and admin surfaces separate from the NAS.
- The NAS owns the media workflow and the private utility stack.
- Homepage acts as the public-safe catalog for all the moving pieces.
- Grafana receives health and usage signals so the repo tells the story of an observed system, not just a list of names.

## Repository Map

- [docs/architecture.md](docs/architecture.md) - architecture overview and runtime topology
- [docs/implementation.md](docs/implementation.md) - implementation story from first service to current split
- [docs/service-catalog.md](docs/service-catalog.md) - public-safe service inventory
- [docs/operations.md](docs/operations.md) - everyday checks and deployment flow
- [docs/screenshots/README.md](docs/screenshots/README.md) - guidance for public captures
- [manifests/homepage-services.example.yaml](manifests/homepage-services.example.yaml) - Homepage layout example
- [manifests/homepage-cluster.example.yaml](manifests/homepage-cluster.example.yaml) - cluster-facing Homepage example
- [manifests/homepage-nas.example.yaml](manifests/homepage-nas.example.yaml) - NAS-facing Homepage example
- [manifests/homepage-observability.example.yaml](manifests/homepage-observability.example.yaml) - monitoring example

## Public Safety

- Secrets, tokens, passwords, and private hostnames stay out of the repo.
- The docs show patterns, not credentials.
- Any sensitive operational detail is intentionally omitted so the project can be shared publicly with confidence.
