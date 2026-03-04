#!/bin/bash
ID=${1:-1}
BASE_DIR="$HOME/KIX_DEDICATED_$ID"
VPS_IP=$(curl -s ifconfig.me)

mkdir -p "$BASE_DIR/homepage/config" "$BASE_DIR/nginx" "$BASE_DIR/data/lnbits" "$BASE_DIR/data/alby"
cd "$BASE_DIR"

cat <<EOF > nginx/default.conf
server {
    listen 80;
    server_name $VPS_IP;
    location / {
        proxy_pass http://kix-dash-$ID:3000;
        proxy_set_header Host \$host;
    }
}
EOF

cat <<EOF > docker-compose.yml
services:
  kix-proxy-$ID:
    image: nginx:alpine
    container_name: kix-proxy-$ID
    ports: ["80:80"]
    volumes: ["./nginx/default.conf:/etc/nginx/conf.d/default.conf:ro"]
  kix-dash-$ID:
    image: ghcr.io/gethomepage/homepage:latest
    container_name: kix-dash-$ID
    volumes: ["./homepage/config:/app/config"]
  kix-engine-$ID:
    image: lnbits/lnbits:latest
    ports: ["5000:5000"]
    volumes: ["./data/lnbits:/app/data"]
  kix-vault-$ID:
    image: ghcr.io/getalby/hub:latest
    ports: ["8080:8080"]
    volumes: ["./data/alby:/data"]
EOF

sudo docker compose up -d
echo "✅ Dedicated KIX v$ID online at http://$VPS_IP"
