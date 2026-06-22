# Homelab

Raspberry Pi 5 homelab project focused on learning and operating a small production-style platform with Kubernetes, GitOps, observability, and service hardening.

## What is running here

- `k3s` cluster with a Raspberry Pi control plane and a second node for workload distribution
- GitOps-style app delivery with `Argo CD`
- CI/CD automation with `Jenkins`
- Monitoring and dashboards with `Prometheus` and `Grafana`
- Storage and data services backed by `PostgreSQL` and NAS-backed volumes
- Cloudflare Tunnel for controlled public access to selected services
- Supporting service stack for home and side projects, including `Pipita Store`

## Current posture

- Public exposure is intentionally limited to selected applications
- Admin and operational services are kept private by default
- Sensitive components are behind tunnel or access controls where appropriate
- Backups are kept local and excluded from version control

## Pipita Store

`Pipita Store` is the main application currently represented in this repository.

Current characteristics:

- Docker Compose deployment for the app, database, and public reverse proxy
- App bound to localhost only
- Nginx proxy used to publish the storefront safely
- Product media and catalog assets stored locally with the application
- Environment values are injected from local variables; `.env.example` documents the required inputs

## Security notes

- No passwords, API tokens, or private keys should be committed
- Local backups and workspace notes are ignored by Git
- Public documentation should stay high-level and portfolio-friendly

## Roadmap

- Continue documenting the homelab architecture and service inventory
- Keep tightening exposure boundaries for public-facing services
- Improve observability, backup verification, and recovery drills
- Expand deployment notes so the stack is easier to reproduce

## For recruiters

This repository is meant to show a practical home production environment with real operational tradeoffs:

- infrastructure segregation
- reverse proxying and controlled exposure
- backup awareness
- GitOps and automation
- application hardening
