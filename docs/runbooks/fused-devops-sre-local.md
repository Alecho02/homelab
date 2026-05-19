# Fused DevOps + SRE Local Lab (No IaC)

## Stack
- Jenkins: CI orchestration
- Vault: secret source
- ArgoCD: GitOps CD
- k3s: runtime
- Grafana/Prometheus/Loki/Tempo: observability

## Flow
1. Jenkins reads APP_SECRET from Vault.
2. Jenkins builds and pushes Java 17 image.
3. Jenkins updates Kubernetes secret and image tag.
4. ArgoCD keeps manifests reconciled.
5. Grafana observes health, latency, logs and traces.

## Validate
- GET /health
- GET /env
- GET /config
- kubectl rollout status
- dashboards and alerts in Grafana
