#!/bin/bash
set -eo pipefail

function install_kubernetes() {
    log "Setting up Kubernetes (K3s)..."

    [[ "$DRY_RUN" == "true" ]] && {
        log "Would install K3s and Helm"
        return 0
    }

    # Install K3s (disable traefik since we'll use Ambassador)
    curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="${KUBERNETES_VERSION:-v1.28}" \
        sh -s - --disable traefik --disable metrics-server

    # Configure kubectl access
    export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
    sudo chmod 644 "$KUBECONFIG"
    mkdir -p ~/.kube
    sudo cp "$KUBECONFIG" ~/.kube/config

    # Verify cluster
    kubectl cluster-info || error "Kubernetes cluster failed to start"

    log "Kubernetes (K3s) installed successfully"
}

function install_helm() {
    log "Installing Helm..."

    curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

    # Add required Helm repos
    helm repo add bitnami https://charts.bitnami.com/bitnami || error "Failed to add Bitnami repo"
    helm repo add datawire https://app.getambassador.io || error "Failed to add Ambassador repo"
    helm repo update

    log "Helm installed successfully"
}

# --- Execute ---
install_kubernetes
install_helm
