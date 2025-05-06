#!/usr/bin/env bash
set -euo pipefail
trap 'echo -e "${YELLOW}[NPM] Error on line $LINENO${NC}"' ERR

# Colors
BLUE='\033[0;34m'; BOLD_BLUE='\033[1;34m'
MAGENTA='\033[0;35m'; YELLOW='\033[0;33m'; GREEN='\033[0;32m'
NC='\033[0m'

# Header function
header() {
  echo -e "${BLUE}───────────────────────────────────────────────${NC}"
  echo -e "${BOLD_BLUE}$1${NC}"
}

# Status message (bold blue)
statusMessage() {
  echo -e "${BOLD_BLUE}$1${NC}"
}

# Skip if disabled
if ! [[ "$NPM_STATUS" =~ ^(true|1)$ ]]; then
  exit 0
fi

# Start
header "[NPM] Starting NPM"

# Change dictory
cd /home/container/www

# NPM install
statusMessage "[NPM] install"
npm install

# NPM run build
statusMessage "[NPM] run build"
npm run build
