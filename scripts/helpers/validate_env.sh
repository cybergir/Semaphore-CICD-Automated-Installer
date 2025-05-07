#!/bin/bash
set -eo pipefail

source ./scripts/helpers/versions.sh

# Required variables
REQUIRED_VARS=(
    DOMAIN
    EMAIL
    KUBERNETES_VERSION
    INSTALL_K3S
    SEMAPHORE_ADMIN_EMAIL
    SEMAPHORE_ADMIN_PASSWORD
)

# Validate .env file exists
if [ ! -f "./configs/.env" ]; then
    echo "Error: .env file not found in configs/"
    exit 1
fi

# Load .env
set -a
source ./configs/.env
set +a

# Check required variables
for VAR in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!VAR}" ]; then
        echo "Error: $VAR is not set in configs/.env"
        exit 1
    fi
done

# Validate email formats
validate_email() {
    local email="$1"
    if [[ ! "$email" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
        echo "Error: Invalid email format for $email"
        exit 1
    fi
}

validate_email "$EMAIL"
validate_email "$SEMAPHORE_ADMIN_EMAIL"

# Validate password strength
if [[ ! "$SEMAPHORE_ADMIN_PASSWORD" =~ ^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{8,}$ ]]; then
    echo "Error: Password must be 8+ chars with uppercase, lowercase, and numbers"
    exit 1
fi

echo "Environment validation passed!"
