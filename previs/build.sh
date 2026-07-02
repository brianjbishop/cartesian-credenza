#!/bin/zsh
# Rebuild previs/index.html from src/app.js + src/template.html.
# Bundles Three.js inline so the page is fully self-contained (works via
# file://, sandboxed webviews, or any static server — no network needed).
set -e
cd "$(dirname "$0")"

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

cp src/app.js "$WORK/"
cd "$WORK"
npm init -y > /dev/null
npm install --no-audit --no-fund three@0.164.0 esbuild > /dev/null
npx esbuild app.js --bundle --minify --format=iife --outfile=bundle.js
cd - > /dev/null

node -e "
const fs = require('fs');
const tpl = fs.readFileSync('src/template.html', 'utf8');
const bundle = fs.readFileSync('$WORK/bundle.js', 'utf8');
if (bundle.includes('</script')) throw new Error('bundle contains </script — cannot inline safely');
fs.writeFileSync('index.html', tpl.replace('/*__BUNDLE__*/', () => bundle));
console.log('index.html rebuilt:', fs.statSync('index.html').size, 'bytes');
"
