#!/bin/bash

if [ "$NPM_MIRROR" != "" ]; then
  npm config set registry $NPM_MIRROR
fi

npm install @slidev/cli @slidev/theme-default @slidev/theme-seriph
npm install --save-dev playwright-chromium

if [ -f /slidev/slides.md ]; then
    echo "Start slidev..."
    
else
    echo "slides.md not found in the bind mount to /slidev"
    cp -f /usr/local/lib/node_modules/@slidev/cli/template.md /slidev/slides.md
    sed -i ':a;N;$!ba;s/GitHub"\n/GitHub"/g' /slidev/slides.md

fi

npx slidev --remote
