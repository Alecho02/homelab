# Implementation Story

This document explains how the homelab grew from a simple public app into a layered platform with a cluster, a NAS, and observability around both.

## Phase 1: The Public Edge

The first layer was the storefront itself.

- `Pipita Store` runs as a containerized application
- `PostgreSQL` stores the application data
- `Nginx` exposes the app through a controlled reverse proxy

This gives the repo a clean public-facing service to anchor the rest of the story.

## Phase 2: The Cluster

The cluster became the control point for platform services.

- The Raspberry Pi acts as the k3s control-plane
- The `qnas` node works as the worker side
- `Traefik` handles ingress for cluster services
- `Cloudflare Tunnel` exposes selected services without broad inbound access
- `Homepage` keeps the internal service catalog readable
- `Headlamp` and `pgAdmin` cover cluster and database visibility

This is the point where the project stops being just an app stack and becomes a platform.

## Phase 3: The NAS

The NAS is where the media and utility stack lives.

- About 6 TB of RAID1 storage holds the media and shared data
- `Portainer` helps manage the containerized NAS services
- `Pi-hole` handles DNS and ad blocking
- `Tailscale` provides private remote access

The NAS side stays outside the cluster where that split is simpler and cleaner operationally.

## Phase 4: Media Automation

The media workflow is built as a chain instead of a single app.

- `Jellyfin` serves the library
- `Jellyseerr` handles requests
- `Radarr` and `Sonarr` automate movie and series management
- `Bazarr` manages subtitles
- `Prowlarr` feeds indexers into the workflow
- `FlareSolverr` helps with resolver behavior where needed
- `qBittorrent` handles downloads
- `Jellystat` gives visibility into usage and consumption

That chain is what makes the NAS feel like a real ecosystem instead of a loose app pile.

## Phase 5: Observability

Once the services were in place, the next step was to make them visible.

- `Prometheus` collects metrics
- `Grafana` turns those metrics into dashboards
- `Alertmanager` handles alert routing and status

Grafana is treated as the presentation layer for the platform's health, usage, and service status so the stack can be explained without revealing private targets.

## Phase 6: Public Documentation

The final step is making the whole thing presentable.

- Sanitized manifests show how Homepage is organized
- Screenshots show the live services in use
- The docs explain the topology, the service catalog, and the operational split

This is the part that turns the homelab into a portfolio piece.

## What Stays Private

- Passwords and tokens
- Private hostnames and IPs
- Backup data and sensitive operational notes
- Any internal service detail that would weaken the security posture if published
