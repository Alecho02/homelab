# Service Catalog

This page documents the public-facing and home-facing services in the homelab without exposing secrets or internal credentials.

## NAS Platform

The NAS is the home for the media and utility stack, backed by about 6 TB of RAID1 storage and managed through Portainer where containers are involved.
It is the place where media flows in, gets automated, and becomes available through the rest of the platform.

## Internet

- `Pipita Store` - public storefront
- `Jellyfin` - media server
- `Jellyseerr` - request workflow for movies and series
- `Grafana` - dashboard access for the lab

## Media And Downloads

- `Jellyfin` - media server
- `Jellyseerr` - request workflow for movies and series
- `Radarr` - movie management
- `Sonarr` - series management
- `Bazarr` - subtitles
- `Prowlarr` - indexer management
- `FlareSolverr` - resolver for indexers
- `Jellystat` - Jellyfin statistics
- `qBittorrent` - downloads

## Network And DNS

- `Pi-hole` - DNS and ad blocking
- `Tailscale` - private mesh access for admin and remote reachability
- `Portainer` - container management on the NAS

## Observability

- `Grafana` - dashboards and metrics
- `Prometheus` - metrics collection and scraping
- `Alertmanager` - alert routing and status

Grafana is treated as the visibility layer for the lab, so it can show service health, usage patterns, and the status of the media automation chain without exposing private targets.

## Cluster And Access

- `Cloudflare Tunnel` - selected public exposure for cluster services
- `Traefik` - Kubernetes ingress and service exposure
- `Homepage` - internal service catalog and landing page

## Cluster

- `Headlamp` - Kubernetes visibility
- `pgAdmin` - PostgreSQL administration
- Router admin - local network management

## Notes

- Public documentation keeps the service list high level.
- Private addresses, keys, and credentials are intentionally omitted.
- This catalog is meant to show the shape of the platform, not the sensitive details.
