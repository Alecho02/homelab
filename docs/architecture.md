# Architecture

## Overview

The homelab is organized around a small Kubernetes-first platform with a separate application stack for `Pipita Store`.

## Principles

- Keep the public footprint small
- Separate infrastructure concerns from app concerns
- Prefer GitOps over manual drift
- Avoid committing secrets or private operational data

## Core Layers

- Compute: Raspberry Pi nodes running `k3s`
- Deployment: `Argo CD`
- Observability: `Grafana`, `Prometheus`, alerting components
- Exposure: Cloudflare Tunnel and local reverse proxying
- Storage: NAS-backed persistent data and backups

## Public vs Private

Only the parts that help explain the system are published here. Admin access, secrets, and internal-only services stay private.
