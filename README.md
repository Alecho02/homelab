# Homelab

Repositorio público para documentar y versionar la construcción de nuestro clúster homelab.

## Objetivo
- Tener infraestructura reproducible.
- Guardar manifiestos y configuración por componente.
- Documentar decisiones técnicas y operación diaria.
- Llevar control de presupuesto/costos.

## Estructura
- `manifests/` → YAML/Kustomize/Helm values por capa.
- `docs/` → arquitectura, operación y runbooks.
- `budget/` → estimaciones y costos reales.
- `scripts/` → utilidades de bootstrap/validación.

## Flujo recomendado
1. Cambios por PR.
2. Validación YAML/Kubernetes en CI.
3. Documentar cada instalación en `docs/operations/`.
4. Registrar impacto en costos en `budget/`.

## Convenciones
- Nombres en minúsculas con guiones.
- Un directorio por componente en `manifests/apps/`.
- Todo cambio técnico relevante debe incluir actualización de documentación.
