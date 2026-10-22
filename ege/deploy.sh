#!/bin/bash

# Exit immediately if any command fails
set -e

# --- CONFIGURATION ---
USER="root"
SERVER_IP="45.141.101.133"
REMOTE_DIR="/var/www/zametki/ege" # Trailing slash is important
KEY_PATH="$HOME/.ssh/id_ed25519_kanura"
# ---------------------

echo "📦 Step 1: Building Astro project locally..."
mdbook build

echo "🚀 Step 2: Deploying files to VPS via rsync..."

ssh -i "$KEY_PATH" "$USER@$SERVER_IP" "mkdir -p $REMOTE_DIR"
# FIXED: Added the -e flag with your explicit KEY_PATH so it stops asking for passwords.
# FIXED: Added --perms and --chmod flags to ensure Caddy can read files uploaded by root.
rsync -avz --delete \
  -e "ssh -i $KEY_PATH" \
  --perms --chmod=Du=rwx,Dg=rx,Do=rx,Fu=rw,Fg=r,Fo=r \
  ./book/ "$USER@$SERVER_IP:$REMOTE_DIR"

echo "🎉 Deployment complete! Your site is live at https://kanura.space/ffac729515532b6713d3df7acee00c90"
