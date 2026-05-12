# Operaciones - Paso a paso

## 1) Creación del repositorio (sin datos sensibles)
1. Se creó una llave SSH dedicada para automatización local.
2. Se registró la **clave pública** en GitHub.
3. Se creó el repositorio público `homelab`.
4. Se inicializó estructura base y se hizo primer push a `main`.

> Nota: La clave privada nunca se sube al repositorio.

## 2) Estructura documental y técnica
Se organizaron carpetas para:
- manifiestos (`manifests/`)
- arquitectura/operación/runbooks (`docs/`)
- costos (`budget/`)
- utilidades (`scripts/`)

## 3) Manifiestos iniciales agregados
- `ingress-nginx` (controlador ingress)
- `cert-manager` (TLS automático)
- `kube-prometheus-stack` (monitoring)

## 4) Qué debes ajustar antes de desplegar
1. Correo en `clusterissuer-*.yaml` (`admin@example.com` → correo real).
2. Password de Grafana (`change-me` → secreto real).
3. Tipo de servicio del ingress según tu entorno (`LoadBalancer`, `NodePort`, etc.).

## 5) Validación recomendada
- Crear PR con cambios.
- Confirmar que GitHub Actions pase `yamllint`.
- Validar en clúster de pruebas antes de producción.

## 6) Buenas prácticas
- No comitear secretos, tokens ni kubeconfigs.
- Documentar cada cambio operacional en este directorio.
- Mantener runbooks actualizados tras incidentes o mejoras.
