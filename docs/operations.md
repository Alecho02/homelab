# Operations

## Routine Tasks

- Check service health
- Review deployment status
- Validate backups
- Confirm observability alerts
- Refresh the Homepage catalog when services change
- Keep the public docs and manifests aligned with the live stack

## Deployment Flow

1. Update the Git repository
2. Bring the storefront stack up with `docker compose`
3. Apply sanitized cluster or portal manifests directly when needed
4. Verify app health, proxy behavior, and service visibility
5. Check logs and metrics for regressions
6. Confirm the Raspberry Pi and `qnas` placements still match the intended split
7. Update the public-safe service catalog when the NAS or cluster changes

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
kubectl apply -f manifests/homepage-services.example.yaml
kubectl apply -f manifests/homepage-cluster.example.yaml
kubectl apply -f manifests/homepage-nas.example.yaml
kubectl apply -f manifests/homepage-observability.example.yaml
```

## Safety Rules

- Never commit secrets
- Keep private notes and backups out of Git
- Document changes in a way that is safe for public sharing
