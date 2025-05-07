#!/bin/bash
# Version pinning for reproducible installations
export KUBERNETES_VERSION="v1.28.5+k3s1" # Updated to working version
export HELM_VERSION="v3.14.0"
export EMISSARY_VERSION="3.8.0"
export CERTBOT_VERSION="2.10.0"
export SEMAPHORE_CHART_VERSION="2.8.90"

# Architecture detection
export ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/aarch64/arm64/')"
export K3S_BIN_URL="https://github.com/k3s-io/k3s/releases/download/${KUBERNETES_VERSION}/k3s"
export K3S_IMAGES_URL="https://github.com/k3s-io/k3s/releases/download/${KUBERNETES_VERSION}/k3s-airgap-images-${ARCH}.tar.gz"

# Export all versions
export ALL_VERSIONS=$(
    cat <<EOF
{
  "kubernetes": "${KUBERNETES_VERSION}",
  "helm": "${HELM_VERSION}",
  "emissary": "${EMISSARY_VERSION}",
  "certbot": "${CERTBOT_VERSION}",
  "semaphore": "${SEMAPHORE_CHART_VERSION}"
}
EOF
)
