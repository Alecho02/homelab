# PostgreSQL + pgAdmin (estado actual)

## Componentes
- PostgreSQL: namespace `data`, service `postgres:5432`
- pgAdmin: namespace `pgadmin`, URL `http://pgadmin.192.168.10.118.nip.io`
- Métricas: `postgres-exporter` en namespace `monitoring`

## Credenciales
- PostgreSQL y pgAdmin se guardan en secretos cifrados SOPS:
  - `security/sops/secrets/postgres-auth.enc.yaml`
  - `security/sops/secrets/pgadmin-auth.enc.yaml`

## Comandos útiles
Obtener password actual de pgAdmin:
```bash
kubectl -n pgadmin get secret pgadmin-auth -o jsonpath='{.data.PGADMIN_DEFAULT_PASSWORD}' | base64 -d; echo
```

Probar conexión a PostgreSQL:
```bash
kubectl -n data exec postgres-0 -- sh -lc 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "select now();"'
```

Ver estado de exporter:
```bash
kubectl -n monitoring logs deploy/postgres-exporter --tail=50
```
