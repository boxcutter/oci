#!/bin/bash

set -euo pipefail

cd /slidev

if [ -n "${NPM_MIRROR:-}" ]; then
    npm config set registry "$NPM_MIRROR"
fi

# npm maintains node_modules/.package-lock.json as a record of the last
# install, so only reinstall when package.json or the lockfile is newer.
INSTALL_MARKER=node_modules/.package-lock.json

if [ ! -f package.json ]; then
    echo "package.json not found in /slidev, installing Slidev..."
    npm install --no-audit --no-fund @slidev/cli @slidev/theme-default @slidev/theme-seriph
    npm install --no-audit --no-fund --save-dev playwright-chromium
elif [ ! -d node_modules ] && [ -f package-lock.json ]; then
    echo "Installing dependencies from package-lock.json..."
    npm ci --no-audit --no-fund
elif [ ! -f "$INSTALL_MARKER" ] \
    || [ package.json -nt "$INSTALL_MARKER" ] \
    || { [ -f package-lock.json ] && [ package-lock.json -nt "$INSTALL_MARKER" ]; }; then
    echo "Installing dependencies from package.json..."
    npm install --no-audit --no-fund
fi

if [ -f "$INSTALL_MARKER" ]; then
   touch "$INSTALL_MARKER"
fi

if [ ! -f slides.md ]; then
    echo "slides.md not found in /slidev, creating one from the Slidev template"
    cp node_modules/@slidev/cli/template.md slides.md
fi

exec npx slidev "$@"
