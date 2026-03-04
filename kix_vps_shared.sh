#!/bin/bash
ID=${1:-1}
PORT_DASH=$((8000 + ID))
PORT_ENGINE=$((5000 + ID))
PORT_VAULT=$((8080 + ID))
BASE_DIR="$HOME/KIX_SHARED_$ID"
VPS_IP=$(curl -s ifconfig.me)

mkdir -p "$BASE_DIR/homepage/config" "$BASE_DIR/data/lnbits" "$BASE_DIR/data/alby"
cd "$BASE_DIR"

cat <<EOF > docker-compose.yml
services:
  kix-dash-$ID:
    image: ghcr.io/gethomepage/homepage:latest
    ports: ["$PORT_DASH:3000"]
    volumes: ["./homepage/config:/app/config"]
  kix-engine-$ID:
    image: lnbits/lnbits:latest
    ports: ["$PORT_ENGINE:5000"]
    volumes: ["./data/lnbits:/app/data"]
  kix-vault-$ID:
    image: ghcr.io/getalby/hub:latest
    ports: ["$PORT_VAULT:8080"]
    volumes: ["./data/alby:/data"]
EOF

# Configura o services.yaml com as portas dinâmicas
cat <<EOF > homepage/config/services.yaml
- KIX Shared v$ID:
    - Engine: { href: "http://$VPS_IP:$PORT_ENGINE" }
    - Vault: { href: "http://$VPS_IP:$PORT_VAULT" }
EOF

sudo docker compose up -d
echo "✅ Shared KIX v$ID online at http://$VPS_IP:$PORT_DASH"
