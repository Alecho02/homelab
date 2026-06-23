# Operations

## Routine Tasks

- Check service health
- Review deployment status
- Validate backups
- Confirm observability alerts
- Refresh the Homepage catalog when services change

## Deployment Flow

1. Update the Git repository
2. Bring the storefront stack up with `docker compose`
3. Apply sanitized cluster or portal manifests directly when needed
4. Verify app health, proxy behavior, and service visibility
5. Check logs and metrics for regressions
6. Confirm the Raspberry Pi and `qnas` placements still match the intended split

## Useful Checks

```bash
kubectl get nodes -o wide
kubectl get pods -A -o wide
kubectl get svc -A
kubectl get pvc -A
kubectl get ingress -A
docker compose ps
docker compose logs -f
docker compose config
docker system df
```

## Safety Rules

- Never commit secrets
- Keep private notes and backups out of Git
- Document changes in a way that is safe for public sharing
