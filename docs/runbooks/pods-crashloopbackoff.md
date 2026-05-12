# Runbook: Pods en CrashLoopBackOff

## Síntoma
- Uno o más pods en estado `CrashLoopBackOff`.
- Servicio degradado o caído.

## Causa probable
1. Error de configuración/env vars.
2. Secret/ConfigMap faltante.
3. Fallo de conexión a dependencia (DB, API, DNS).
4. Límite de memoria insuficiente (OOMKilled).

## Diagnóstico (orden recomendado)
1) Eventos y rollout
```bash
kubectl get deploy -n <ns>
kubectl rollout status deploy/<app> -n <ns>
kubectl get events -n <ns> --sort-by=.lastTimestamp | tail -n 30
```
2) Estado del pod
```bash
kubectl get pods -n <ns>
kubectl describe pod <pod> -n <ns>
```
3) Logs actual y anterior
```bash
kubectl logs <pod> -n <ns> --tail=200
kubectl logs <pod> -n <ns> --previous --tail=200
```
4) Presión de recursos
```bash
kubectl top pod -n <ns>
kubectl describe node <node-name>
```
5) Red básica
```bash
kubectl get svc -n <ns>
kubectl get endpoints -n <ns>
```

## Mitigación inmediata
- Si inició tras deploy reciente: rollback.
```bash
kubectl rollout undo deploy/<app> -n <ns>
kubectl rollout status deploy/<app> -n <ns>
```
- Si es OOMKilled: subir `resources.limits.memory` temporalmente.
- Si falta secreto/config: restaurar objeto faltante y reiniciar rollout.

## Solución definitiva
- Corregir causa raíz en código/config.
- Definir requests/limits realistas.
- Añadir probes (`readiness/liveness/startup`) correctas.
- Validar en staging antes de pasar a producción.

## Verificación final
```bash
kubectl get pods -n <ns>
kubectl rollout status deploy/<app> -n <ns>
```
Criterio de éxito: pods `Running/Ready`, sin reinicios crecientes, servicio restaurado.

## Rollback
- `kubectl rollout undo` al revision estable.
- Revert en Git del manifiesto problemático y reconciliación GitOps.
