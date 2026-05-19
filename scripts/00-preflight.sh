#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

echo "== OS =="
cat /etc/os-release
uname -a

echo
echo "== Hardware =="
lscpu | sed -n '1,25p'
free -h
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS,MODEL

echo
echo "== Network =="
ip -br addr
ip route
base_domain="$(grep '^BASE_DOMAIN=' inventory.env | cut -d= -f2)"
getent hosts "home.${base_domain}" || true

echo
echo "== Kubernetes prerequisites =="
if [[ -f /sys/fs/cgroup/cgroup.controllers ]] && grep -qw memory /sys/fs/cgroup/cgroup.controllers; then
  echo "OK: cgroup v2 memory controller is available."
elif grep -qw 'cgroup_disable=memory' /proc/cmdline; then
  echo "FAIL: memory cgroup is unavailable and cgroup_disable=memory is present. Run sudo ./scripts/02-fix-cgroups.sh and reboot."
else
  echo "WARN: could not confirm memory cgroup availability."
fi

if sudo -n true >/dev/null 2>&1; then
  echo "OK: sudo works without interactive password."
else
  echo "WARN: sudo needs an interactive password/TTY."
fi

for bin in curl git jq rg gh helm kubectl k3s; do
  if command -v "$bin" >/dev/null 2>&1; then
    echo "OK: $bin"
  else
    echo "MISSING: $bin"
  fi
done
