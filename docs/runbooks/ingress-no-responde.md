# Runbook: Ingress no responde

## Síntoma
- Las apps publicadas por Ingress devuelven timeout/502/404 inesperado.

## Causa probable
1. Controlador `ingress-nginx` caído o no saludable.
2. Service/Endpoints del backend sin pods listos.
3. Reglas Ingress mal aplicadas.
4. DNS o IP externa desactualizada.

## Diagnóstico
> Reemplaza `<ns>` y `<app>` según aplique.

```bash
kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx
kubectl get ingress -A
kubectl describe ingress <app> -n <ns>
kubectl get svc -n <ns>
kubectl get endpoints -n <ns>
kubectl logs -n ingress-nginx deploy/ingress-nginx-controller --tail=200
kubectl get events -A --sort-by=.lastTimestamp | tail -n 50
```

## Mitigación inmediata
1. Reiniciar controlador si está degradado:
```bash
kubectl rollout restart deploy/ingress-nginx-controller -n ingress-nginx
kubectl rollout status deploy/ingress-nginx-controller -n ingress-nginx
```
2. Si backend está sin endpoints, escalar/reparar deployment backend.
3. Corregir host/path del Ingress y re-aplicar manifiesto.

## Solución definitiva
- Agregar healthchecks en backend.
- Validar rutas/hosts en PR antes de merge.
- Configurar alertas por `5xx` y por falta de endpoints.

## Verificación final
```bash
kubectl get ingress -A
kubectl get endpoints -n <ns>
curl -I https://<tu-dominio>
```
Criterio de éxito: respuesta HTTP esperada y sin errores recurrentes en logs del controlador.

## Rollback
- Revertir al commit previo de manifiestos:
```bash
git revert <commit>
git push
```
- Si usas Flux/ArgoCD, esperar reconciliación y confirmar estado estable.
