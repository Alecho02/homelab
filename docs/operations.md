# Operations

## Routine Tasks

- Check service health
- Review deployment status
- Validate backups
- Confirm observability alerts

## Deployment Flow

1. Update the Git repository
2. Let `Argo CD` reconcile the desired state
3. Verify app health and ingress behavior
4. Check logs and metrics for regressions

## Safety Rules

- Never commit secrets
- Keep private notes and backups out of Git
- Document changes in a way that is safe for public sharing
