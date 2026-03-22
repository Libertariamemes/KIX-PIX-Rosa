#!/bin/bash

# 1. Definição da Instância e Portas Dinâmicas
ID=${1:-1}
BASE_DIR="$HOME/KIX_DEDICATED_HEADLESS_$ID"
VPS_IP=$(curl -s ifconfig.me)

# Cálculo de portas (Injetadas diretamente no Host)
PORT_ENGINE=$((5000 + ID))
PORT_VAULT=$((8080 + ID))
PORT_P2P=$((9734 + ID))

echo "🚀 Iniciando KIX Dedicated v$ID - Modo Host Soberano"
echo "🌐 IP Detectado: $VPS_IP"

# 2. Criação da Estrutura de Pastas
mkdir -p "$BASE_DIR/data/lnbits" "$BASE_DIR/data/alby"
sudo chown -R 1000:1000 "$BASE_DIR/data/alby" "$BASE_DIR/data/lnbits"

cd "$BASE_DIR"

# 3. Geração do Docker Compose (Gerenciamento via Host)
# ... (restante do script igual)

# 3. Geração do Docker Compose (Com Comando de Porta Forçado)
cat <<EOF > docker-compose.yml
services:
  kix-engine-$ID:
    image: lnbits/lnbits:latest
    container_name: kix-engine-$ID
    restart: unless-stopped
    network_mode: host
    env_file:
      - .env
    # FORÇA O LNBITS A OUVIR NA PORTA DO ID
    command: ["uv", "run", "lnbits", "--port", "$PORT_ENGINE", "--host", "0.0.0.0"]
    volumes:
      - ./data/lnbits:/app/data

  kix-vault-$ID:
    image: ghcr.io/getalby/hub:latest
    container_name: kix-vault-$ID
    restart: unless-stopped
    network_mode: host
    environment:
      - PORT=$PORT_VAULT
      - P2P_PORT=$PORT_P2P
      - WORKDIR=/root/.local/share/albyhub
    volumes:
      - ./data/alby:/root/.local/share/albyhub
EOF

# ... (restante do script igual)

# 4. Configuração Interna do LNbits
cat <<EOF > .env
LNBITS_BACKEND_WALLET_CLASS=VoidWallet
LNBITS_DATA_FOLDER=/app/data
HOST=0.0.0.0
PORT=$PORT_ENGINE
EOF

# 5. Subir Containers (Detached Mode)
sudo docker compose up -d

# 6. Salvar e Exibir Links (Sua função favorita)
LINKS_FILE="$BASE_DIR/kix_clearnet_links.txt"

cat <<EOF > "$LINKS_FILE"
--- KIX DEDICATED HEADLESS v$ID ---
Gerado em: $(date)
Modo de Rede: HOST (Soberania Total)

💰 ENGINE (LNbits): http://$VPS_IP:$PORT_ENGINE
🔐 VAULT (Alby):    http://$VPS_IP:$PORT_VAULT
⚡ LIGHTNING P2P:  $VPS_IP:$PORT_P2P

(Portas gerenciadas automaticamente pelo Framework KIX)
EOF

clear
echo "================================================================"
echo "    ✅ KIX v$ID INSTALADO (CLEARNET HEADLESS)"
echo "================================================================"
cat "$LINKS_FILE"
echo "================================================================"
echo "📂 O arquivo de links está em: $LINKS_FILE"
echo "📝 Para visualizar novamente, use o comando:"
echo "cat $LINKS_FILE"
echo "================================================================"
