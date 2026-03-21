#!/bin/bash

# 1. Definição da Instância e Portas Dinâmicas
ID=${1:-10}
BASE_DIR="$HOME/KIX_Soberano_v$ID"

# Cálculo de portas para evitar colisão na VPS
PORT_ENGINE=$((5000 + ID))
PORT_VAULT=$((8080 + ID))

echo "🛡️ Iniciando KIX Headless (v$ID) em: $BASE_DIR"
echo "🔌 Portas Locais: Engine->$PORT_ENGINE | Vault->$PORT_VAULT"

# 2. Limpeza Seletiva
if [ -d "$BASE_DIR" ]; then
    echo "🧹 limpando v$ID anterior..."
    cd "$BASE_DIR" && sudo docker compose down 2>/dev/null
    cd ~ && sudo rm -rf "$BASE_DIR"
fi

# 3. Estrutura de Pastas
mkdir -p "$BASE_DIR/data/lnbits" "$BASE_DIR/data/alby" "$BASE_DIR/data/tor"
sudo chown -R 1000:1000 "$BASE_DIR/data/alby" "$BASE_DIR/data/lnbits"

cd "$BASE_DIR"

# 4. Docker Compose com Portas Variáveis
cat <<EOF > docker-compose.yml
services:
  kix-engine-v$ID:
    image: lnbits/lnbits:latest
    container_name: kix-engine-v$ID
    restart: unless-stopped
    ports:
      - "$PORT_ENGINE:5000"
    env_file: [.env]
    volumes: [./data/lnbits:/app/data]

  kix-vault-v$ID:
    image: ghcr.io/getalby/hub:latest
    container_name: kix-vault-v$ID
    restart: unless-stopped
    ports:
      - "$PORT_VAULT:8080"
    volumes: [./data/alby:/root/.local/share/albyhub]

  kix-tor-v$ID:
    image: alpine:latest
    container_name: kix-tor-v$ID
    restart: unless-stopped
    user: root
    command: >
      sh -c "apk add --no-cache tor &&
             mkdir -p /var/lib/tor/engine /var/lib/tor/vault &&
             chown -R tor:tor /var/lib/tor &&
             chmod -R 700 /var/lib/tor &&
             echo 'DataDirectory /var/lib/tor' > /etc/tor/torrc &&
             echo 'HiddenServiceDir /var/lib/tor/engine/' >> /etc/tor/torrc &&
             echo 'HiddenServicePort 80 kix-engine-v$ID:5000' >> /etc/tor/torrc &&
             echo 'HiddenServiceDir /var/lib/tor/vault/' >> /etc/tor/torrc &&
             echo 'HiddenServicePort 80 kix-vault-v$ID:8080' >> /etc/tor/torrc &&
             su -s /bin/sh tor -c 'tor -f /etc/tor/torrc'"
    volumes: [./data/tor:/var/lib/tor]
EOF

# 5. Env Inicial
echo -e "LNBITS_BACKEND_WALLET_CLASS=VoidWallet\nLNBITS_DATA_FOLDER=/app/data\nHOST=0.0.0.0\nPORT=5000" > .env

# 6. Start
sudo docker compose up -d

echo "⏳ Aguardando geração dos links .onion (isso leva uns 30s)..."

# Usamos 'sudo test -f' para checar a existência de arquivos protegidos
while ! sudo test -f "data/tor/vault/hostname" || ! sudo test -f "data/tor/engine/hostname"; do
    sleep 2
    echo -n "."
    
    # Adicionando um contador de segurança para não travar o script para sempre
    COUNT=$((COUNT + 1))
    if [ "$COUNT" -ge 60 ]; then
        echo -e "\n❌ Erro: O Tor demorou demais para gerar as chaves."
        exit 1
    fi
done
echo -e "\n✅ Chaves geradas com sucesso!"

# 7. Captura e Exibição Final (Com SUDO para ler o Volume do Tor)
echo -e "\n🔍 Extraindo chaves Onion..."

# Usamos sudo aqui porque o DataDirectory do Tor tem permissões 700 para o usuário tor (UID 100)
ENGINE_ONION=$(sudo cat "$BASE_DIR/data/tor/engine/hostname" 2>/dev/null)
VAULT_ONION=$(sudo cat "$BASE_DIR/data/tor/vault/hostname" 2>/dev/null)

if [ -z "$ENGINE_ONION" ] || [ -z "$VAULT_ONION" ]; then
    echo "❌ Erro ao ler os hostnames. Verifique se os containers estão rodando com 'docker ps'."
    exit 1
fi


echo "================================================"
echo "    🚀 KIX v$ID INSTALADO (MODO TOR-ONLY) "
echo "================================================"
echo "💰 ENGINE (LNbits):"
echo "   Onion: http://$ENGINE_ONION"
echo "   Local: http://localhost:$PORT_ENGINE"
echo ""
echo "🔐 VAULT (Alby Hub):"
echo "   Onion: http://$VAULT_ONION"
echo "   Local: http://localhost:$PORT_VAULT"
echo "================================================"
echo "📂 O arquivo de links está em: $BASE_DIR/onion_links.txt"
echo "📝 Para visualizar novamente, use o comando:"
echo "cat $BASE_DIR/onion_links.txt"
echo "================================================================"
# Salva no arquivo com permissão de usuário comum para facilitar seu acesso depois
echo -e "Engine: http://$ENGINE_ONION\nVault: http://$VAULT_ONION" | tee "$BASE_DIR/onion_links.txt" > /dev/null
