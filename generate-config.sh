#!/bin/bash

# Traefik Hub Dynamic Configuration Generator
# Generates config/dynamic.yml from template with environment variables

set -e

# Load environment variables from .env file
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Validate required variables
if [ -z "$DOMAIN" ] || [ -z "$JWKS_URL" ]; then
    echo "Error: Required environment variables DOMAIN and JWKS_URL not set"
    exit 1
fi

# Generate dynamic configuration from template
envsubst < config/dynamic.yml.template > config/dynamic.yml

echo "✅ Dynamic configuration generated successfully"
echo "   JWKS URL: $JWKS_URL"