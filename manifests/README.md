# Manifiestos

Esta carpeta organiza la infraestructura del clúster por dominios funcionales.

## Convención
- Un subdirectorio por componente.
- Cada componente incluye su `kustomization.yaml`.
- Valores sensibles se dejan como placeholders.

## Capas
- `networking/`
  - `ingress-nginx/`: controlador de ingress.
  - `cert-manager/`: gestión de TLS con Let's Encrypt.
- `observability/`
  - `kube-prometheus-stack/`: métricas, alertas y dashboards.
  - `exposure/`: ingress locales para Grafana, Prometheus y Alertmanager.
- `apps/`
  - `homepage/`: portal visual para acceder a servicios del homelab.
  - `headlamp/`: dashboard Kubernetes para pods, servicios y workloads.

## Orden recomendado de despliegue
1. `networking/ingress-nginx`
2. `networking/cert-manager`
3. `observability/kube-prometheus-stack`
4. `apps/headlamp` (namespace + instalación Helm)
5. `apps/homepage`

## Notas importantes
- Antes de producción, cambia:
  - `admin@example.com` en ClusterIssuers.
  - `change-me` en Grafana.
- Si no usas Flux, adapta los recursos `HelmRelease/HelmRepository` a Helm CLI o ArgoCD.
