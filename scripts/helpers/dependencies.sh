#!/bin/bash
set -eo pipefail

function install_dependencies() {
    log "Installing system dependencies..."

    [[ "$DRY_RUN" == "true" ]] && {
        log "Would run: apt-get update && apt-get upgrade -y"
        return 0
    }

    sudo apt-get update -qq
    sudo apt-get upgrade -y -qq

    # Core packages
    sudo apt-get install -y -qq \
        curl \
        git \
        jq \
        unzip \
        apt-transport-https \
        ca-certificates \
        gnupg-agent \
        software-properties-common

    log "Dependencies installed successfully"
}

install_dependencies
