#!/bin/bash
set -eo pipefail

function install_ambassador() {
    log "Installing Ambassador/Emissary-ingress..."

    [[ "$DRY_RUN" == "true" ]] && {
        log "Would install Ambassador CRDs and Helm chart"
        return 0
    }

    # Install CRDs (required for Semaphore)
    kubectl apply -f https://app.getambassador.io/yaml/emissary/3.7.0/emissary-crds.yaml

    # Wait for CRDs to register
    sleep 10

    # Install Ambassador Helm chart
    helm upgrade -i emissary datawire/emissary-ingress \
        --namespace emissary \
        --create-namespace \
        --set replicaCount=1 \
        --set enableAES=false

    # Verify installation
    kubectl wait --timeout=90s --for=condition=available deployment emissary-ingress -n emissary ||
        error "Ambassador deployment failed"

    log "Ambassador installed successfully"
}

# --- Execute ---
install_ambassador
