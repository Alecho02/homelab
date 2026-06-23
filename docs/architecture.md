# Architecture

## Overview

The homelab is organized around a public storefront plus a broader home service platform. The goal is to show how the pieces fit together without exposing private implementation details.

## Principles

- Keep the public footprint small
- Separate infrastructure concerns from app concerns
- Prefer simple, repeatable operations over one-off fixes
- Avoid committing secrets or private operational data

## Core Layers

- Public app layer: `Pipita Store` with `PostgreSQL` and `Nginx`
- Cluster layer: k3s on a Raspberry Pi control-plane with a `qnas` worker
- Access layer: `Traefik` and `Cloudflare Tunnel` for selected cluster exposure
- Media layer: `Jellyfin`, `Jellyseerr`, `Radarr`, `Sonarr`, `Bazarr`, `Prowlarr`, `FlareSolverr`, `Jellystat`, `qBittorrent`
- Network layer: `Pi-hole` and `Portainer`
- Observability layer: `Grafana`, `Prometheus`, `Alertmanager`
- Cluster/admin layer: `Homepage`, `Headlamp`, `pgAdmin`
- Storage: NAS-backed persistent data, media, and backups

## Runtime Topology

- The Raspberry Pi hosts the control-plane, the storefront proxy, and most admin-facing cluster services.
- `qnas` acts as the worker side for tunnel, ingress, and a portion of observability.
- The NAS side also carries shared media, download, and backup workloads outside the cluster where that is the cleanest fit.
- Public app traffic is kept separate from internal cluster services.

## Public vs Private

Only the parts that help explain the system are published here. Admin access, secrets, and internal-only services stay private.
