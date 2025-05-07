#!/bin/bash
set -eo pipefail

# --- Constants ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

LOG_FILE="${LOG_FILE:-./logs/install.log}"
CONFIG_FILE="${CONFIG_FILE:-./configs/.env}"

# --- Functions ---
function log() {
    echo -e "${YELLOW}[$(date '+%Y-%m-%d %H:%M:%S')] $1${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >>"$LOG_FILE"
}

function error() {
    echo -e "${RED}[ERROR] $1${NC}" >&2
    echo "[ERROR] $1" >>"$LOG_FILE"
    exit 1
}

function load_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        error "Config file not found: $CONFIG_FILE"
    fi
    source "$CONFIG_FILE"
    log "Loaded configuration from $CONFIG_FILE"
}

# --- Main ---
function main() {
    mkdir -p ./logs
    echo "=== Semaphore CI/CD Installation Log ===" >"$LOG_FILE"

    log "Starting Semaphore CI/CD installation"
    load_config

    # Execute installation steps
    source "./scripts/helpers/dependencies.sh"
    source "./scripts/helpers/kubernetes.sh"
    source "./scripts/helpers/ambassador.sh"
    source "./scripts/helpers/certbot.sh"
    source "./scripts/helpers/semaphore.sh"

    log "Installation completed successfully!"
}

# --- Execution ---
if [[ "$1" == "--dry-run" ]]; then
    log "Dry-run mode activated (no changes will be made)"
    export DRY_RUN=true
fi

main "$@"
