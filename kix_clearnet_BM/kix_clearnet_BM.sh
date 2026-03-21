#!/bin/bash

# 1. Definição da Instância e Portas Dinâmicas
ID=${1:-1}
BASE_DIR="$HOME/KIX_DEDICATED_HEADLESS_$ID"
VPS_IP=$(curl -s ifconfig.me)

# Cálculo de portas dinâmicas
PORT_ENGINE=$((5000 + ID))
PORT_VAULT=$((8080 + ID))

echo "🚀 Iniciando KIX Dedicated Headless (v$ID) - Sem Dashboard"
echo "🌐 IP da VPS detectado: $VPS_IP"
echo "📂 Diretório: $BASE_DIR"

# 2. Criação da Estrutura de Pastas (Apenas Dados)
mkdir -p "$BASE_DIR/data/lnbits"
mkdir -p "$BASE_DIR/data/alby"

# Ajuste de permissões
sudo chown -R 1000:1000 "$BASE_DIR/data/alby"
sudo chown -R 1000:1000 "$BASE_DIR/data/lnbits"

cd "$BASE_DIR"

# 3. Geração do Docker Compose (Apenas Engine e Vault)
cat <<EOF > docker-compose.yml
services:
  kix-engine-$ID:
    image: lnbits/lnbits:latest
    container_name: kix-engine-$ID
    restart: unless-stopped
    ports:
      - "$PORT_ENGINE:5000"
    env_file:
      - .env
    volumes:
      - ./data/lnbits:/app/data

  kix-vault-$ID:
    image: ghcr.io/getalby/hub:latest
    container_name: kix-vault-$ID
    restart: unless-stopped
    ports:
      - "$PORT_VAULT:8080"
    volumes:
      - ./data/alby:/root/.local/share/albyhub
EOF

# 4. Arquivos de Configuração Iniciais
cat <<EOF > .env
LNBITS_BACKEND_WALLET_CLASS=VoidWallet
LNBITS_DATA_FOLDER=/app/data
HOST=0.0.0.0
PORT=5000
EOF

# 5. Subir Containers
sudo docker compose up -d

# 6. Salvar e Exibir Links
LINKS_FILE="$BASE_DIR/kix_clearnet_links.txt"

cat <<EOF > "$LINKS_FILE"
--- KIX DEDICATED HEADLESS v$ID ---
Gerado em: $(date)
Acesso via IP Público: $VPS_IP

💰 ENGINE (LNbits): http://$VPS_IP:$PORT_ENGINE
🔐 VAULT (Alby):    http://$VPS_IP:$PORT_VAULT

(Dashboard removido para máxima economia de recursos)
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
