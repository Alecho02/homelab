#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run as root: sudo $0" >&2
  exit 1
fi

if [[ -f /sys/fs/cgroup/cgroup.controllers ]] && grep -qw memory /sys/fs/cgroup/cgroup.controllers; then
  echo "OK: cgroup v2 memory controller is available."
elif grep -qw 'cgroup_disable=memory' /proc/cmdline; then
  echo "memory cgroup is unavailable and cgroup_disable=memory is still active. Run scripts/02-fix-cgroups.sh and reboot first." >&2
  exit 1
fi

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --disable traefik --write-kubeconfig-mode 644 --node-ip 192.168.10.118" sh -

mkdir -p /home/pi/.kube
cp /etc/rancher/k3s/k3s.yaml /home/pi/.kube/config
chown -R pi:pi /home/pi/.kube

kubectl get nodes -o wide
