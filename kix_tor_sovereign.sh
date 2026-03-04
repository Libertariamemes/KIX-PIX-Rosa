#!/bin/bash

# 1. Definição da Instância (Padrão v2 se não passar argumento)
ID=${1:-2}
BASE_DIR="$HOME/KIX_PROTOTIPO$ID"

echo "🛡️ Iniciando Instalação KIX Soberana (TOR) - Instância v$ID"

# 2. Limpeza Seletiva (Apenas desta instância)
echo "🧹 Limpando resíduos da v$ID..."
if [ -d "$BASE_DIR" ]; then
    cd "$BASE_DIR" && sudo docker compose down 2>/dev/null
    cd ~ && sudo rm -rf "$BASE_DIR"
fi

# 3. Criação da Estrutura
mkdir -p "$BASE_DIR/homepage/config"
mkdir -p "$BASE_DIR/data/lnbits"
mkdir -p "$BASE_DIR/data/alby"
mkdir -p "$BASE_DIR/data/tor/dash"
mkdir -p "$BASE_DIR/data/tor/engine"
mkdir -p "$BASE_DIR/data/tor/vault"

cd "$BASE_DIR"

# 4. Geração do Docker Compose Dinâmico
echo "📝 Gerando Docker Compose para v$ID..."
cat <<EOF > docker-compose.yml
services:
  kix-dash-v$ID:
    image: ghcr.io/gethomepage/homepage:latest
    container_name: kix-dash-v$ID
    restart: unless-stopped
    pull_policy: if_not_present
    volumes:
      - ./homepage/config:/app/config
    environment:
      - HOMEPAGE_ALLOWED_HOSTS=*

  kix-engine-v$ID:
    image: lnbits/lnbits:latest
    container_name: kix-engine-v$ID
    restart: unless-stopped
    pull_policy: if_not_present
    env_file:
      - .env
    volumes:
      - ./data/lnbits:/app/data

  kix-vault-v$ID:
    image: ghcr.io/getalby/hub:latest
    container_name: kix-vault-v$ID
    restart: unless-stopped
    pull_policy: if_not_present
    volumes:
      - ./data/alby:/data

  kix-tor-v$ID:
    image: alpine:latest
    container_name: kix-tor-v$ID
    restart: unless-stopped
    pull_policy: if_not_present
    user: root
    command: >
      sh -c "apk add --no-cache tor &&  
             mkdir -p /var/lib/tor/dash /var/lib/tor/engine /var/lib/tor/vault &&
             chown -R tor:tor /var/lib/tor &&
             chmod -R 700 /var/lib/tor &&
             echo 'DataDirectory /var/lib/tor' > /etc/tor/torrc &&
             echo 'HiddenServiceDir /var/lib/tor/dash/' >> /etc/tor/torrc &&
             echo 'HiddenServicePort 80 kix-dash-v$ID:3000' >> /etc/tor/torrc &&
             echo 'HiddenServiceDir /var/lib/tor/engine/' >> /etc/tor/torrc &&
             echo 'HiddenServicePort 80 kix-engine-v$ID:5000' >> /etc/tor/torrc &&
             echo 'HiddenServiceDir /var/lib/tor/vault/' >> /etc/tor/torrc &&
             echo 'HiddenServicePort 80 kix-vault-v$ID:8080' >> /etc/tor/torrc &&
             su -s /bin/sh tor -c 'tor -f /etc/tor/torrc'"
    volumes:
      - ./data/tor:/var/lib/tor
EOF

# 5. Arquivos de Configuração
echo "⚙️ Configurando .env e Settings..."
cat <<EOF > .env
LNBITS_BACKEND_WALLET_CLASS=VoidWallet
LNBITS_DATA_FOLDER=./data
HOST=0.0.0.0
PORT=5000
EOF

echo "title: \"KIX Soberano v$ID\"" > homepage/config/settings.yaml
echo 'background: "#0a0a0a"' >> homepage/config/settings.yaml

# 6. Subir Containers
sudo docker compose up -d

echo "⏳ Aguardando geração dos endereços Onion (aprox. 45s)..."
# Loop de verificação para não esperar tempo demais à toa
for i in {1..60}; do
    if [ -f "data/tor/dash/hostname" ]; then break; fi
    sleep 1
done

# 7. Captura dos Endereços
DASH_ONION=$(sudo cat data/tor/dash/hostname)
ENGINE_ONION=$(sudo cat data/tor/engine/hostname)
VAULT_ONION=$(sudo cat data/tor/vault/hostname)

# 8. Finalizando Services.yaml com endereços Onion
cat <<EOF > homepage/config/services.yaml
- Grupo KIX Soberano v$ID:
    - Engine (LNbits):
        icon: lnbits.png
        href: http://$ENGINE_ONION
        description: Pagamentos Bitcoin (.onion)
    - Vault (Alby):
        icon: alby.png
        href: http://$VAULT_ONION
        description: Gestão de Chaves (.onion)
EOF

echo "------------------------------------------------"
echo "✨ INSTALAÇÃO v$ID CONCLUÍDA ✨"
echo "------------------------------------------------"
echo "🌐 DASHBOARD ONION: http://$DASH_ONION"
echo "------------------------------------------------"
