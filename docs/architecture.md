# Architecture

## Overview

The homelab is organized around three clean boundaries: a public storefront, a Kubernetes control plane for platform services, and a NAS-backed media and utility layer. The point of the repo is to show how those layers work together without exposing private implementation details.

## Design Goals

- Keep the public footprint small
- Separate infrastructure concerns from app concerns
- Prefer repeatable operations over one-off fixes
- Make the platform easy to explain in a portfolio
- Never commit secrets or private operational data

## Core Layers

- Public app layer: `Pipita Store` with `PostgreSQL` and `Nginx`
- Cluster layer: k3s on a Raspberry Pi control-plane with a `qnas` worker
- Access layer: `Traefik` and `Cloudflare Tunnel` for selected cluster exposure
- NAS layer: about 6 TB of RAID1 storage for media, backups, and shared data
- Media layer: `Jellyfin`, `Jellyseerr`, `Radarr`, `Sonarr`, `Bazarr`, `Prowlarr`, `FlareSolverr`, `Jellystat`, `qBittorrent`
- Network layer: `Pi-hole`, `Tailscale`, and `Portainer`
- Observability layer: `Grafana`, `Prometheus`, `Alertmanager`
- Cluster/admin layer: `Homepage`, `Headlamp`, `pgAdmin`

## Runtime Topology

- The Raspberry Pi hosts the control-plane and the services that make the cluster easy to manage.
- `qnas` acts as the worker side for tunnel, ingress, and a portion of observability.
- The NAS keeps the media, download, and admin tooling outside the cluster where that split is simpler and safer.
- `Tailscale` gives private remote access to NAS and admin services without broad public exposure.
- The media automation chain is centered on `Jellyfin`, `Jellyseerr`, `Radarr`, `Sonarr`, `Bazarr`, `Prowlarr`, `FlareSolverr`, `Jellystat`, and `qBittorrent`.
- Grafana receives service health and usage signals from exporters, checks, and app metrics so the system is visible as an actual platform.
- Public app traffic stays separated from the internal cluster services.

## Implementation Shape

The platform reads like a series of deliberate layers instead of a single pile of containers:

1. The storefront runs as a containerized app stack.
2. `PostgreSQL` keeps the application data isolated from the edge.
3. `Nginx` publishes the storefront through a controlled public entry point.
4. The Raspberry Pi anchors the k3s control plane.
5. The NAS holds the media automation stack and the utility services.
6. `Traefik`, `Cloudflare Tunnel`, and `Homepage` provide clean access patterns for the cluster side.
7. `Prometheus`, `Grafana`, and `Alertmanager` make the platform observable.
8. Sanitized manifests and docs let the repo present the real system safely.

## Public vs Private

Only the parts that help explain the system are published here. Admin access, secrets, private endpoints, and internal-only services stay private.
