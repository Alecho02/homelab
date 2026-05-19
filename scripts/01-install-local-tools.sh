#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="${HOME}/.npm-global/bin"
mkdir -p "$BIN_DIR"

arch="$(uname -m)"
if [[ "$arch" != "aarch64" && "$arch" != "arm64" ]]; then
  echo "Unsupported architecture for this script: $arch" >&2
  exit 1
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
cd "$tmp"

if ! command -v kubectl >/dev/null 2>&1; then
  curl -fsSLo "$BIN_DIR/kubectl" "https://dl.k8s.io/release/$(curl -fsSL https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
  chmod +x "$BIN_DIR/kubectl"
fi

if ! command -v helm >/dev/null 2>&1; then
  helm_ver="$(curl -fsSL https://api.github.com/repos/helm/helm/releases/latest | sed -n 's/.*"tag_name": "v\([^"]*\)".*/\1/p' | head -n1)"
  curl -fsSLo helm.tgz "https://get.helm.sh/helm-v${helm_ver}-linux-arm64.tar.gz"
  tar -xzf helm.tgz
  cp linux-arm64/helm "$BIN_DIR/helm"
  chmod +x "$BIN_DIR/helm"
fi

kubectl version --client=true
helm version --short

