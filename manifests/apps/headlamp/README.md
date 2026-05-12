# Headlamp

Instalación vía Helm (chart oficial):

```bash
helm repo add headlamp https://kubernetes-sigs.github.io/headlamp/
helm repo update
helm upgrade --install headlamp headlamp/headlamp \
  -n headlamp --create-namespace \
  -f manifests/apps/headlamp/values.yaml
```

URL local:
- http://headlamp.192.168.10.118.nip.io

Token read-only para login:
```bash
kubectl create token headlamp-viewer -n headlamp
```
