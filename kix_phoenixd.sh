#!/bin/bash
# PHOENIX_MULTI_HUNTER: Fixed Integration with .env Backup

ID=${1:-"v1"}
REAL_USER=$(logname)
REAL_HOME=$(eval echo ~$REAL_USER)
BASE_DIR="$REAL_HOME/PHOENIX_$ID"
PHOENIX_PASS=$(openssl rand -hex 16)

echo "------------------------------------------------"
echo "🚀 Initializing Isolated Instance: $ID"
echo "------------------------------------------------"

mkdir -p "$BASE_DIR/data/lnbits" "$BASE_DIR/data/tor"
cd "$BASE_DIR"

cat <<EOF > docker-compose.yml
services:
  phoenix-$ID:
    image: acinq/phoenixd:latest
    container_name: phoenix-$ID
    restart: unless-stopped
    volumes:
      - phoenix_data_$ID:/home/phoenix/.phoenix
    command: "--agree-to-terms-of-service --http-bind-ip 0.0.0.0 --http-password=$PHOENIX_PASS"

  engine-$ID:
    image: lnbits/lnbits:latest
    container_name: engine-$ID
    restart: unless-stopped
    env_file: .env
    volumes:
      - ./data/lnbits:/app/data
    depends_on:
      - phoenix-$ID

  tor-$ID:
    image: alpine:latest
    container_name: tor-$ID
    restart: unless-stopped
    user: root
    command: >
      sh -c "apk add --no-cache tor &&
             mkdir -p /var/lib/tor/engine &&
             chown -R tor:tor /var/lib/tor &&
             chmod -R 700 /var/lib/tor &&
             echo 'DataDirectory /var/lib/tor' > /etc/tor/torrc &&
             echo 'HiddenServiceDir /var/lib/tor/engine/' >> /etc/tor/torrc &&
             echo 'HiddenServicePort 80 engine-$ID:5000' >> /etc/tor/torrc &&
             exec su -s /bin/sh tor -c 'tor -f /etc/tor/torrc'"
    volumes:
      - ./data/tor:/var/lib/tor

volumes:
  phoenix_data_$ID:
EOF

# 4. Environment Configuration
cat <<EOF > .env
HOST=0.0.0.0
PORT=5000
LNBITS_DATA_FOLDER=/app/data
LNBITS_BACKEND_WALLET_CLASS=PhoenixdWallet
PHOENIXD_API_ENDPOINT=http://phoenix-$ID:9740
PHOENIXD_API_PASSWORD=$PHOENIX_PASS
EOF

# --- NEW: Save .env to a text file for backup ---
cp .env env_backup.txt

sudo docker compose up -d

echo "⏳ Waiting 30 seconds for alignment..."
sleep 30

SEED_PATH=$(sudo find /var/lib/docker/volumes/ -ipath "*$ID*/_data/seed.dat" -print -quit)
TOR_ADDRESS_PATH="$BASE_DIR/data/tor/engine/hostname"

{
    echo "------------------------------------------------"
    echo "INSTANCE: $ID | STATUS: DEPLOYED"
    echo "------------------------------------------------"
    echo "🔑 PHOENIX API PASS: $PHOENIX_PASS"
    echo "🔗 INTERNAL URL:    http://phoenix-$ID:9740"
    echo ""
    if [ -f "$TOR_ADDRESS_PATH" ]; then
        echo "🌍 TOR ADDRESS:    http://$(sudo cat $TOR_ADDRESS_PATH)"
    fi
    echo ""
    echo "📂 FOLDER PATH:     $BASE_DIR"
    echo "📄 ENV BACKUP:      $BASE_DIR/env_backup.txt"
    echo "------------------------------------------------"
    echo "📝 .ENV CONTENTS:"
    cat .env
    echo "------------------------------------------------"
} | tee "$BASE_DIR/nodeinfo.txt"

echo ""
echo "✅ Configuration backed up and saved to: $BASE_DIR/nodeinfo.txt"
