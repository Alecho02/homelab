# Homelab

This repository documents a Raspberry Pi 5 homelab built as a small production-style platform for learning, portfolio work, and repeatable operations.

## Current Stack

- `k3s` cluster with Raspberry Pi control-plane and a worker node
- GitOps deployment flow with `Argo CD`
- Observability stack with `Grafana`, `Prometheus`, and alerting components
- Cloudflare Tunnel for controlled public exposure
- NAS-backed storage and backup workflows
- Supporting home services such as media, dashboards, and admin tools
- `Pipita Store`, a separate app deployment kept in the same homelab ecosystem

## What This Repo Shows

- Infrastructure organization and service boundaries
- Public vs private exposure decisions
- Containerized workloads and reverse proxying
- Backup awareness and restore-friendly layouts
- Practical homelab operations without leaking secrets

## Pipita Store

`Pipita Store` is the current application deployment included here.

Highlights:

- Docker Compose deployment for app, database, and public proxy
- App published through a local Nginx reverse proxy
- Database credentials injected from environment variables
- Local product media and assets kept out of Git

## Security Posture

- No passwords, API tokens, or private keys are committed
- Local backups, workspace notes, and generated artifacts are ignored
- Public docs stay high-level and portfolio-friendly
- Admin and operational surfaces remain private unless explicitly exposed

## Notes for Reviewers

This homelab is meant to read like a real, maintained environment rather than a demo:

- the stack is segmented
- exposure is intentional
- the docs are kept current with the deployment
- the goal is to show practical DevOps and cloud engineering habits
