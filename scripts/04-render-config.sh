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

mkdir -p generated

render() {
  local src="$1"
  local dst="$2"
  SRC="$src" DST="$dst" python3 - <<'PY'
from pathlib import Path
import os

src = Path(os.environ["SRC"])
dst = Path(os.environ["DST"])
replacements = {
    "__BASE_DOMAIN__": os.environ["BASE_DOMAIN"],
    "__NODE_IP__": os.environ["NODE_IP"],
    "__NAS_IP__": os.environ["NAS_IP"],
    "__PIHOLE_BASE_URL__": os.environ["PIHOLE_BASE_URL"],
    "__PIHOLE_URL__": os.environ["PIHOLE_URL"],
    "__JELLYFIN_URL__": os.environ["JELLYFIN_URL"],
    "__PORTAINER_URL__": os.environ["PORTAINER_URL"],
    "__QBITTORRENT_URL__": os.environ["QBITTORRENT_URL"],
    "__PGADMIN_EMAIL__": os.environ["PGADMIN_EMAIL"],
}
text = src.read_text()
for old, new in replacements.items():
    text = text.replace(old, new)
dst.write_text(text)
PY
}

render k8s/apps/homepage/homepage.yaml.tpl generated/homepage.yaml
render k8s/apps/pgadmin/pgadmin.yaml.tpl generated/pgadmin.yaml

echo "Rendered generated/homepage.yaml and generated/pgadmin.yaml"
