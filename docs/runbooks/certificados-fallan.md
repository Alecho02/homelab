# Runbook: Certificados no emiten o no renuevan

## Síntoma
- Certificado TLS en estado `False/Unknown`.
- Navegador muestra certificado vencido/no confiable.

## Causa probable
1. `ClusterIssuer` mal configurado (email/server/solver).
2. Challenge HTTP-01 no enruta correctamente por Ingress.
3. Rate limit de Let's Encrypt.
4. Problemas DNS (host no apunta al ingress actual).

## Diagnóstico
```bash
kubectl get clusterissuer
kubectl describe clusterissuer letsencrypt-staging
kubectl describe clusterissuer letsencrypt-prod
kubectl get certificate -A
kubectl describe certificate <cert-name> -n <ns>
kubectl get certificaterequest -A
kubectl get challenge -A
kubectl get order -A
kubectl logs -n cert-manager deploy/cert-manager --tail=300
```

## Mitigación inmediata
1. Probar primero con `letsencrypt-staging` para evitar rate limits.
2. Verificar que el host DNS apunta a la IP pública correcta.
3. Confirmar que el Ingress usa clase correcta (`nginx`).

## Solución definitiva
- Ajustar `ClusterIssuer` y manifiestos Ingress.
- Mantener staging para pruebas y prod solo en cambios validados.
- Agregar alerta por certificados próximos a vencer (<15 días).

## Verificación final
```bash
kubectl get certificate -A
kubectl describe certificate <cert-name> -n <ns>
```
Criterio de éxito: `Ready=True` y renovación programada sin errores.

## Rollback
- Revertir cambios recientes en `ClusterIssuer/Ingress`.
- Aplicar manifiestos previos estables y validar emisión en staging.
