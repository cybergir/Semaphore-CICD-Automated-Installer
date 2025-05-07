#!/bin/bash
set -eo pipefail

function install_semaphore() {
    log "Installing Semaphore CI/CD..."

    [[ "$DRY_RUN" == "true" ]] && {
        log "Would deploy Semaphore with Helm"
        return 0
    }

    # Select Helm values based on server resources
    local VALUES_FILE
    local TOTAL_RAM=$(free -m | awk '/Mem:/ {print $2}')

    if [ "$TOTAL_RAM" -lt 2048 ]; then
        VALUES_FILE="./configs/values/small.yaml"
        log "Detected small server (<2GB RAM), using optimized config"
    elif [ "$TOTAL_RAM" -lt 8192 ]; then
        VALUES_FILE="./configs/values/medium.yaml"
        log "Detected medium server (2-8GB RAM)"
    else
        VALUES_FILE="./configs/values/large.yaml"
        log "Detected large server (>8GB RAM)"
    fi

    # Helm install with dynamic values
    helm upgrade -i semaphore semaphoreci/semaphore \
        --namespace semaphore \
        --create-namespace \
        -f "$VALUES_FILE" \
        --set ingress.hosts[0].host="$DOMAIN" \
        --set ingress.tls[0].secretName="semaphore-tls" \
        --set admin.email="$SEMAPHORE_ADMIN_EMAIL" \
        --set admin.password="$SEMAPHORE_ADMIN_PASSWORD" || error "Semaphore Helm install failed"

    # Wait for deployment
    kubectl rollout status deployment semaphore -n semaphore --timeout=300s ||
        error "Semaphore deployment failed"

    log "Semaphore installed! Access via: https://$DOMAIN"
}

# --- Execute ---
install_semaphore
