#!/bin/bash
set -eo pipefail

function install_certbot() {
    log "Installing Certbot for SSL certificates..."

    [[ "$DRY_RUN" == "true" ]] && {
        log "Would request SSL certificate for $DOMAIN"
        return 0
    }

    # Install Certbot
    sudo apt-get install -y certbot python3-certbot-dns-cloudflare || error "Certbot installation failed"

    # Validate domain is reachable
    dig +short "$DOMAIN" | grep -q "." || error "Domain $DOMAIN does not resolve"

    # Request certificate (DNS challenge for better reliability)
    sudo certbot certonly --standalone \
        --non-interactive \
        --agree-tos \
        --email "$EMAIL" \
        --domains "$DOMAIN" \
        --preferred-challenges http || error "Certificate request failed"

    # Create Kubernetes TLS secret
    kubectl create secret tls semaphore-tls \
        --cert /etc/letsencrypt/live/$DOMAIN/fullchain.pem \
        --key /etc/letsencrypt/live/$DOMAIN/privkey.pem \
        --dry-run=client -o yaml | kubectl apply -f -

    log "SSL certificate installed for $DOMAIN"
}

# --- Execute ---
install_certbot
