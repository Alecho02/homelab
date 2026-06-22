# Homelab Portfolio

This repository is a public-facing snapshot of my current homelab. It is written to be portfolio-friendly: useful for LinkedIn, clear about what the system does, and careful not to expose secrets.

## What It Represents

- A small Raspberry Pi based homelab built for learning and repeatable operations
- A current stack centered on `k3s`, `Argo CD`, observability, and controlled public exposure
- A separate application deployment, `Pipita Store`, kept inside the same ecosystem

## Current Stack

- `k3s` cluster with a Raspberry Pi control-plane and worker node
- GitOps deployment flow with `Argo CD`
- Observability with `Grafana`, `Prometheus`, and alerting components
- Cloudflare Tunnel for controlled public access
- NAS-backed storage and backup workflows
- Supporting home services such as media, dashboards, and admin tools
- `Pipita Store` as a separate application deployment

## What This Repo Shows

- Infrastructure organization and service boundaries
- Public vs private exposure decisions
- Containerized workloads and reverse proxying
- Backup awareness and restore-friendly layouts
- Practical homelab operations without leaking secrets

## Pipita Store

`Pipita Store` is the current application deployment included in the homelab ecosystem.

Highlights:

- Docker Compose deployment for app, database, and public proxy
- App published through a local Nginx reverse proxy
- Database credentials injected from environment variables
- Local product media and assets kept out of Git

## Security Posture

- No passwords, API tokens, or private keys are committed
- Local backups, workspace notes, and generated artifacts are ignored
- Public docs stay high-level and professional
- Admin and operational surfaces remain private unless explicitly exposed

## Suggested Repo Structure

```text
homelab-portfolio/
  README.md
  .gitignore
  docs/
    architecture.md
    operations.md
```

## Notes

This repo is intentionally smaller than a full production backup. The goal is to present a believable, maintainable homelab story that reads well in a portfolio or LinkedIn profile.
