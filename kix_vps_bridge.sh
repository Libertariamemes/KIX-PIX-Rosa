#!/bin/bash
# Este script deve rodar na VPS que tem o IP Público
read -p "Digite o IP da Tailscale da máquina LOCAL: " TS_IP
read -p "Digite o ID da instância (ex: 1): " ID
read -p "Digite o seu domínio (ou deixe em branco para usar o IP): " DOMAIN

PORT_DASH=$((8000 + ID))
CONF_FILE="/etc/nginx/sites-available/kix_bridge_$ID"
SERVER_NAME=${DOMAIN:-$(curl -s ifconfig.me)}

echo "🔗 Criando ponte: VPS:80 -> Tailscale ($TS_IP:$PORT_DASH)"

sudo apt update && sudo apt install -y nginx

cat <<EOF | sudo tee $CONF_FILE
server {
    listen 80;
    server_name $SERVER_NAME;

    location / {
        proxy_pass http://$TS_IP:$PORT_DASH;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
EOF

sudo ln -s $CONF_FILE /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl restart nginx

echo "✨ Bridge configurada! Acesse http://$SERVER_NAME"
