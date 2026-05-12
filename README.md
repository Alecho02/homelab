# Homelab

Repositorio público para documentar y versionar la construcción del clúster homelab, sin exponer datos sensibles.

## Qué incluye
- Manifiestos Kubernetes por capas (`manifests/`).
- Documentación técnica y operativa (`docs/`).
- Control de costos (`budget/`).
- CI básica para validar YAML (`.github/workflows/validate-manifests.yml`).

## Estructura
```text
homelab/
├── manifests/
│   ├── networking/
│   │   ├── ingress-nginx/
│   │   └── cert-manager/
│   ├── observability/
│   │   └── kube-prometheus-stack/
│   └── kustomization.yaml
├── docs/
│   ├── architecture/
│   ├── operations/
│   └── runbooks/
├── budget/
├── scripts/
└── .github/workflows/
```

## Stack base (actual)
- Ingress: `ingress-nginx`
- Certificados: `cert-manager` + `ClusterIssuer` staging/prod
- Observabilidad: `kube-prometheus-stack` (Prometheus + Grafana)

## Guía rápida de uso
1. Clonar repo.
2. Revisar y ajustar valores por entorno (dominio, correo ACME, passwords).
3. Aplicar por capas desde `manifests/` usando Kustomize/Flux.
4. Verificar estado de pods y servicios.
5. Documentar cualquier cambio en `docs/operations/`.

## Seguridad y datos sensibles
- No subir secretos reales al repo.
- Usar placeholders (`admin@example.com`, `change-me`) y reemplazar fuera del control de versiones.
- Guardar credenciales en un gestor de secretos (SOPS, Vault, External Secrets, etc.).

## Flujo recomendado
- Todo cambio por Pull Request.
- Validación automática de YAML en CI.
- Cada cambio técnico debe actualizar documentación y, si aplica, presupuesto.
