# SRE Practice Plan - Homelab k3s

Objetivo: practicar habilidades SRE reales usando tu cluster actual (k3s + ingress-nginx + kube-prometheus-stack + Homepage + Headlamp + pgAdmin).

## Reglas del laboratorio

- Trabaja siempre en ventana de mantenimiento local.
- Haz cambios pequeños y verifica despues de cada paso.
- Evita tocar namespaces criticos fuera del alcance del ejercicio.
- Registra hallazgos en un journal (fecha, cambio, resultado, rollback).

## Estado base (pre-check)

Comandos:

```bash
kubectl get nodes -o wide
kubectl get pods -A
kubectl get ingress -A
kubectl top nodes
kubectl top pods -A
```

Criterio de exito:
- Nodo en `Ready`
- Pods principales en `Running`
- Ingress de Homepage/Grafana/Prometheus/Alertmanager/Headlamp/pgAdmin activos

## Track 1 - Observabilidad y diagnostico

### Ejercicio 1: mapa de salud rapido

Comandos:

```bash
kubectl get pods -A --field-selector=status.phase!=Running
kubectl get events -A --sort-by=.lastTimestamp | tail -50
```

Meta:
- Detectar incidentes recientes en menos de 3 minutos.

### Ejercicio 2: incidente simulado de app

Accion:
- Reinicia `homepage` y valida tiempo de recuperacion.

Comandos:

```bash
kubectl rollout restart deploy/homepage -n homepage
kubectl rollout status deploy/homepage -n homepage --timeout=120s
curl -I http://home.192.168.10.118.nip.io
```

Meta:
- Confirmar causa, impacto y recuperacion.

## Track 2 - Confiabilidad y cambios seguros

### Ejercicio 3: despliegue controlado

Accion:
- Cambia replicas de un deployment no critico y valida rollback.

Comandos:

```bash
kubectl scale deploy/headlamp -n headlamp --replicas=2
kubectl get pods -n headlamp -w
kubectl scale deploy/headlamp -n headlamp --replicas=1
```

Meta:
- Ejecutar cambio + rollback sin downtime visible.

### Ejercicio 4: validar readiness/liveness

Accion:
- Revisar probes de workloads actuales.

Comandos:

```bash
kubectl get deploy -A -o yaml | rg -n "readinessProbe|livenessProbe"
```

Meta:
- Listar workloads sin probes y priorizar mejora.

## Track 3 - Capacidad y performance

### Ejercicio 5: baseline de recursos

Comandos:

```bash
kubectl top nodes
kubectl top pods -A | sort -k3 -hr | head -15
```

Meta:
- Identificar top consumidores de CPU/RAM.

### Ejercicio 6: limites y requests

Comandos:

```bash
kubectl get deploy -A -o jsonpath='{range .items[*]}{.metadata.namespace} {.metadata.name}{"\n"}{range .spec.template.spec.containers[*]}{"  "}{.name}{" req="}{.resources.requests}{" lim="}{.resources.limits}{"\n"}{end}{end}'
```

Meta:
- Crear backlog para definir `requests/limits` donde falten.

## Track 4 - Seguridad operacional

### Ejercicio 7: inventario de secrets y SA

Comandos:

```bash
kubectl get secrets -A
kubectl get sa -A
kubectl auth can-i --list -n homepage
```

Meta:
- Detectar sobrepermisos basicos y secretos huerfanos.

### Ejercicio 8: superficie de entrada

Comandos:

```bash
kubectl get ingress -A -o wide
ss -ltnp
```

Meta:
- Confirmar que solo expones lo esperado en LAN.

## Track 5 - Backup y recuperacion

### Ejercicio 9: respaldo de manifiestos

Comandos:

```bash
mkdir -p backups
kubectl get all -A -o yaml > backups/all-$(date +%F-%H%M).yaml
kubectl get pvc -A -o yaml > backups/pvc-$(date +%F-%H%M).yaml
```

Meta:
- Tener snapshot recuperable de estado declarado.

### Ejercicio 10: restauracion parcial

Accion:
- Eliminar y recrear un recurso no critico (por ejemplo un configmap de prueba).

Meta:
- Practicar recuperacion sin improvisar.

## Track 6 - Mejora continua del homelab

Prioridades sugeridas:

1. Agregar `readiness/liveness` donde falten.
2. Definir `requests/limits` en todos los deployments.
3. Crear runbooks por servicio (`homepage`, `ingress-nginx`, `monitoring`).
4. Programar chequeo diario de salud con cron y alerta.
5. Estandarizar cambios via manifiestos + git.

## Runbooks minimos a crear

- `runbook-homepage.md`
- `runbook-ingress-nginx.md`
- `runbook-monitoring.md`
- `runbook-node-notready.md`
- `runbook-pod-crashloop.md`

Cada runbook debe incluir:
- sintomas
- verificacion
- mitigacion temporal
- solucion permanente
- rollback

## Sprint sugerido (7 dias)

Dia 1:
- Track 1 completo

Dia 2:
- Track 2 completo

Dia 3:
- Track 3 completo

Dia 4:
- Track 4 completo

Dia 5:
- Track 5 completo

Dia 6:
- Documentar runbooks

Dia 7:
- Simulacro final: incidente end-to-end con postmortem

## Postmortem template corto

- Que paso
- Impacto
- Causa raiz
- Que detectamos bien
- Que detectamos tarde
- Acciones correctivas (con owner y fecha)

