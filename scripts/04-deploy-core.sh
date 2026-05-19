#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if [[ ! -f inventory.env ]]; then
  echo "Missing inventory.env" >&2
  exit 1
fi

set -a
source inventory.env
set +a

./scripts/04-render-config.sh

secrets_file="secrets/homelab.enc.env"
if [[ ! -f "$secrets_file" ]]; then
  echo "Missing encrypted secrets file: $secrets_file" >&2
  exit 1
fi

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT
chmod 700 "$tmpdir"
sops -d "$secrets_file" > "$tmpdir/secrets.env"
chmod 600 "$tmpdir/secrets.env"
set -a
source "$tmpdir/secrets.env"
set +a

cat > "$tmpdir/kube-prometheus-stack.yaml" <<EOF
grafana:
  enabled: true
  adminPassword: "${GRAFANA_ADMIN_PASSWORD}"
  ingress:
    enabled: true
    ingressClassName: nginx
    hosts:
      - grafana.${BASE_DOMAIN}
prometheus:
  ingress:
    enabled: true
    ingressClassName: nginx
    hosts:
      - prometheus.${BASE_DOMAIN}
alertmanager:
  ingress:
    enabled: true
    ingressClassName: nginx
    hosts:
      - alertmanager.${BASE_DOMAIN}
EOF

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add headlamp https://kubernetes-sigs.github.io/headlamp/
helm repo update

kubectl apply -f k8s/namespaces.yaml

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  --set controller.service.type=LoadBalancer \
  --set controller.service.externalIPs[0]="${NODE_IP}"

helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace \
  -f "$tmpdir/kube-prometheus-stack.yaml"

helm upgrade --install headlamp headlamp/headlamp \
  --namespace headlamp --create-namespace \
  -f k8s/helm-values/headlamp.yaml

kubectl apply -f k8s/ingress-observability.yaml

kubectl create secret generic homepage-secrets \
  --namespace homepage \
  --from-literal=HOMEPAGE_VAR_PIHOLE_KEY="${PIHOLE_API_KEY:-}" \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl create secret generic pgadmin-secret \
  --namespace pgadmin \
  --from-literal=PGADMIN_DEFAULT_EMAIL="${PGADMIN_EMAIL}" \
  --from-literal=PGADMIN_DEFAULT_PASSWORD="${PGADMIN_PASSWORD}" \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f generated/homepage.yaml
kubectl apply -f generated/pgadmin.yaml

kubectl get pods -A
kubectl get ingress -A
