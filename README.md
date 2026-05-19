# Raspberry Pi 5 Homelab k3s

Rebuild plan for the Raspberry Pi 5 NVMe homelab cluster.

Target node:

- Host: Raspberry Pi 5, 8 GB RAM
- OS: Debian 13 aarch64
- Node IP: `192.168.10.118`
- Local wildcard: `*.192.168.10.118.nip.io`
- Storage: local NVMe via k3s local-path provisioner

Target services on k3s:

- Homepage: `http://home.192.168.10.118.nip.io`
- Grafana: `http://grafana.192.168.10.118.nip.io`
- Prometheus: `http://prometheus.192.168.10.118.nip.io`
- Alertmanager: `http://alertmanager.192.168.10.118.nip.io`
- Headlamp: `http://headlamp.192.168.10.118.nip.io`
- pgAdmin: `http://pgadmin.192.168.10.118.nip.io`
- Jenkins: `http://jenkins.192.168.10.118.nip.io`
- Argo CD: `http://argocd.192.168.10.118.nip.io`

External services linked from Homepage:

- Pi-hole on UGREEN NAS
- Jellyfin on UGREEN NAS
- Portainer on UGREEN NAS
- qBittorrent on UGREEN NAS

## Status

Installed and running as of 2026-05-18:

- k3s v1.35.4+k3s1
- ingress-nginx
- kube-prometheus-stack
- Headlamp
- Homepage
- pgAdmin
- Jenkins
- Argo CD
- tmux
- iptables

All cluster pods were verified running after deployment.

Homepage host validation is configured with:

- `HOMEPAGE_ALLOWED_HOSTS=home.192.168.10.118.nip.io`

## Access

Homepage:

- http://home.192.168.10.118.nip.io

Observability:

- http://grafana.192.168.10.118.nip.io
- http://prometheus.192.168.10.118.nip.io
- http://alertmanager.192.168.10.118.nip.io

Cluster tools:

- http://headlamp.192.168.10.118.nip.io
- http://pgadmin.192.168.10.118.nip.io
- http://jenkins.192.168.10.118.nip.io
- http://argocd.192.168.10.118.nip.io

Credential retrieval:

```bash
# Grafana user: admin
kubectl --namespace monitoring get secret monitoring-grafana -o jsonpath="{.data.admin-password}" | base64 -d; echo

# Headlamp token
kubectl create token headlamp --namespace headlamp

# Jenkins (chart secret)
kubectl get secret jenkins -n jenkins -o jsonpath='{.data.jenkins-admin-password}' | base64 -d; echo

# Argo CD initial admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo

# pgAdmin user is configured in inventory.env as PGADMIN_EMAIL.
# pgAdmin password is stored in secrets/homelab.enc.env.
```

## Secrets

This project uses SOPS + age for homelab secrets.

Files:

- SOPS config: `.sops.yaml`
- Encrypted secrets: `secrets/homelab.enc.env`
- Local age private key: `/home/pi/.config/sops/age/keys.txt`

Decrypt check:

```bash
cd /home/pi/.openclaw/workspace/homelab-k3s
SOPS_AGE_KEY_FILE=/home/pi/.config/sops/age/keys.txt sops -d secrets/homelab.enc.env >/dev/null
```

Edit secrets:

```bash
cd /home/pi/.openclaw/workspace/homelab-k3s
SOPS_AGE_KEY_FILE=/home/pi/.config/sops/age/keys.txt sops secrets/homelab.enc.env
```

Apply after changing secrets:

```bash
cd /home/pi/.openclaw/workspace/homelab-k3s
SOPS_AGE_KEY_FILE=/home/pi/.config/sops/age/keys.txt ./scripts/04-deploy-core.sh
```

Back up the age key somewhere private. Without it, `secrets/homelab.enc.env` cannot be decrypted.

## NAS Notes

UGREEN NAS IP:

- `192.168.10.184`

Reachability from the Pi:

- Portainer: reachable on `https://192.168.10.184:9443` and `http://192.168.10.184:9000`
- Pi-hole: `http://192.168.10.90/admin/login`
- Jellyfin: `http://192.168.10.184:8899/web/#/home.html`
- qBittorrent: `http://192.168.10.184:8888/`
- Portainer: `http://192.168.10.184:9000/#!/auth`

NAS services are configured as Homepage links. Pi-hole also has a Homepage widget using Pi-hole v6 mode and the API key stored in SOPS.

## Recovery Notes

The host originally needed manual intervention before k3s could be installed:

1. `sudo` required a password/TTY.
2. Kernel cmdline included `cgroup_disable=memory`.

Run this from an interactive SSH/local terminal:

```bash
cd /home/pi/.openclaw/workspace/homelab-k3s
sudo ./scripts/02-fix-cgroups.sh
sudo reboot
```

After reboot or disaster recovery:

```bash
cd /home/pi/.openclaw/workspace/homelab-k3s
sudo ./scripts/03-install-k3s.sh
./scripts/04-deploy-core.sh
```

## Configure NAS Links

Edit `inventory.env` before deploying. Current ARP candidates seen from the Pi: `192.168.10.184`, `192.168.10.212`.

For Pi-hole API metrics, set:

```bash
PIHOLE_API_KEY=your_app_password_or_token
```

Keep real secrets out of git and long-term memory.
