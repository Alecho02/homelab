# Arquitectura del Homelab

## Objetivo de arquitectura
Construir un clúster reproducible, observable y fácil de operar para servicios self-hosted.

## Componentes base
- **Networking**
  - `ingress-nginx` como punto de entrada HTTP/HTTPS.
  - `cert-manager` para emisión y renovación de certificados TLS.
- **Observabilidad**
  - `kube-prometheus-stack` para monitoreo y visualización.

## Principios
1. Infraestructura declarativa (GitOps-friendly).
2. Documentación junto al código.
3. Separación entre configuración versionable y secretos.
4. Cambios pequeños y auditables por PR.

## Por completar
- Topología física/lógica de nodos.
- Diseño de red (subredes, DNS, exposición externa).
- Estrategia de backups y recuperación.
