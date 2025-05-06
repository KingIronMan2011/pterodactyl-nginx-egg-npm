#!/usr/bin/env bash
set -euo pipefail
trap 'echo -e "${YELLOW}[ERROR] on line $LINENO${NC}"' ERR

# Colors for output formatting
BLUE='\033[0;34m'; BOLD_BLUE='\033[1;34m'
MAGENTA='\033[0;35m'; YELLOW='\033[0;33m'; GREEN='\033[0;32m'
NC='\033[0m'

# Function to print a header line and message
header() {
  echo -e "${BLUE}───────────────────────────────────────────────${NC}"
  echo -e "${BOLD_BLUE}$1${NC}"
}

# Function to print a status message in bold blue
statusMessage() {
  echo -e "${BOLD_BLUE}$1${NC}"
}

# Exit immediately if NPM_STATUS is not set to true or 1
if ! [[ "${NPM_STATUS:-}" =~ ^(true|1)$ ]]; then
  exit 0
fi

# Set HOME and configure npm cache directory
export HOME=/home/container
export NPM_CONFIG_CACHE="$HOME/.npm"

# Create and secure the npm cache directory
mkdir -p "$NPM_CONFIG_CACHE"
chown -R "$(id -u):$(id -g)" "$NPM_CONFIG_CACHE"
chmod 700 "$NPM_CONFIG_CACHE"

# Start the build pipeline
header "[NPM] Starting build pipeline"

# Change to the application directory
cd /home/container/www

# Install dependencies
statusMessage "[NPM] Running: npm install"
npm install

# Execute the build
statusMessage "[NPM] Running: npm run build"
npm run build

# Ensure the web root directory exists
statusMessage "[NPM] Ensuring /home/container/www/html exists"
if [ ! -d /home/container/www/html ]; then
  mkdir -p /home/container/www/html
  chown -R "$(id -u container):$(id -g container)" /home/container/www/html
fi

# Move build output to the web root
statusMessage "[NPM] Moving build output to /home/container/www/html"
rm -rf /home/container/www/html/*
mv dist/* /home/container/www/html/
