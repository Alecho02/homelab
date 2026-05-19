#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run as root: sudo $0" >&2
  exit 1
fi

cmdline=/boot/firmware/cmdline.txt
backup="${cmdline}.bak.$(date +%Y%m%d-%H%M%S)"

cp "$cmdline" "$backup"
python3 - "$cmdline" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
parts = path.read_text().strip().split()
parts = [p for p in parts if p != "cgroup_disable=memory"]
for required in ("cgroup_enable=cpuset", "cgroup_enable=memory", "cgroup_memory=1"):
    if required not in parts:
        parts.append(required)
path.write_text(" ".join(parts) + "\n")
PY

echo "Updated $cmdline"
echo "Backup: $backup"
echo "Reboot required."

