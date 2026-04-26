#!/bin/bash
set -euo pipefail

if ! docker info >/dev/null 2>&1; then
    echo "❌ docker is not running, please start docker first"
    echo "   sudo systemctl start docker"
    exit 1
fi

# https://developers.cloudflare.com/fundamentals/reference/network-ports/

# ── Cloudflare proxied ─────────────────────────────────────────────
# Trojan-go:  8443 (TCP/WS, via CF, fallback)
# GOST WARP:  2096 (TCP/WS, via CF, fallback)

# ── Direct connection ──────────────────────────────────────────────
# Xray VLESS Reality: 443  (TCP, no CF, primary)
# Hysteria2:          443  (UDP, no CF, primary)

# ══════════════════════════════════════════════════════════════════
# VALUES - edit these before running
# ══════════════════════════════════════════════════════════════════

# ── Cert ──────────────────────────────────────────────────────────
read -rp "enter your domain (e.g. example.com): " DOMAIN
CERT_DIR="$HOME/cert/$DOMAIN"
CERT_FILE="$CERT_DIR/$DOMAIN.pem"
KEY_FILE="$CERT_DIR/$DOMAIN.key"

# xray vless reality
XRAY_CONFIG_PATH='/etc/xray'
VLESS_REALITY_PORT='443'
REALITY_SERVER_NAME='www.microsoft.com'
REALITY_TARGET='www.microsoft.com:443'

# hysteria2
HYSTERIA2_CONFIG_PATH='/etc/hysteria'
HYSTERIA2_PORT='443'
HYSTERIA2_PASSWORD='change-me-hysteria2-password'
HYSTERIA2_MASQUERADE_URL='https://motherfuckingwebsite.com/'

# trojan-go
TROJAN_GO_CONFIG_PATH='/etc/trojan-go'
TROJAN_GO_PORT='8443'
TROJAN_GO_PASSWORD='change-me-trojan-password'
TROJAN_GO_WS_PATH='/trojan-websocket'

# gost warp
GOST_WARP_USERNAME='user'
GOST_WARP_PASSWORD='change-me-gost-password'
GOST_WARP_PORT='2096'
GOST_WARP_WS_PATH='/gost-websocket'

# ══════════════════════════════════════════════════════════════════

generate_uuid() {
    if command -v uuidgen >/dev/null 2>&1; then
        uuidgen | tr '[:upper:]' '[:lower:]'
    elif command -v python3 >/dev/null 2>&1; then
        python3 - <<'PY'
import uuid
print(uuid.uuid4())
PY
    else
        echo 'your-vless-uuid'
    fi
}

generate_short_id() {
    if command -v openssl >/dev/null 2>&1; then
        openssl rand -hex 8
    else
        echo '0123456789abcdef'
    fi
}

generate_reality_keys() {
    if command -v docker >/dev/null 2>&1; then
        local output
        output=$(docker run --rm ghcr.io/xtls/xray-core:latest x25519 2>&1 || true)
        REALITY_PRIVATE_KEY=$(printf '%s\n' "$output" | awk '/PrivateKey:/ {print $2}')
        REALITY_PUBLIC_KEY=$(printf '%s\n' "$output" | awk '/Password \(PublicKey\):/ {print $3}')
        if [[ -n "$REALITY_PRIVATE_KEY" ]]; then
            return 0
        fi
    fi
    REALITY_PRIVATE_KEY='your-reality-private-key'
    REALITY_PUBLIC_KEY='your-reality-public-key'
    echo "⚠️  failed to generate Reality keys, please run manually:"
    echo "    docker run --rm ghcr.io/xtls/xray-core:latest x25519"
    echo "    then fill REALITY_PRIVATE_KEY and REALITY_PUBLIC_KEY in .env"
}

VLESS_UUID=$(generate_uuid)
REALITY_SHORT_ID=$(generate_short_id)
REALITY_PRIVATE_KEY=''
REALITY_PUBLIC_KEY=''
generate_reality_keys

chmod 700 "$CERT_DIR" 2>/dev/null || true
chmod 600 "$CERT_FILE" 2>/dev/null || true
chmod 600 "$KEY_FILE" 2>/dev/null || true

cat > .env <<EOF
# cert
CERT_DIR=$CERT_DIR
CERT_FILE=$CERT_FILE
KEY_FILE=$KEY_FILE

# xray vless reality
XRAY_CONFIG_PATH=$XRAY_CONFIG_PATH
VLESS_REALITY_PORT=$VLESS_REALITY_PORT
VLESS_UUID=$VLESS_UUID
REALITY_PRIVATE_KEY=$REALITY_PRIVATE_KEY
# REALITY_PUBLIC_KEY is for client config only, not used by server
REALITY_PUBLIC_KEY=$REALITY_PUBLIC_KEY
REALITY_SHORT_ID=$REALITY_SHORT_ID
REALITY_SERVER_NAME=$REALITY_SERVER_NAME
REALITY_TARGET=$REALITY_TARGET

# hysteria2
HYSTERIA2_CONFIG_PATH=$HYSTERIA2_CONFIG_PATH
HYSTERIA2_PORT=$HYSTERIA2_PORT
# ⚠️  change this
HYSTERIA2_PASSWORD=$HYSTERIA2_PASSWORD
HYSTERIA2_MASQUERADE_URL=$HYSTERIA2_MASQUERADE_URL

# trojan-go
TROJAN_GO_CONFIG_PATH=$TROJAN_GO_CONFIG_PATH
TROJAN_GO_PORT=$TROJAN_GO_PORT
# ⚠️  change this
TROJAN_GO_PASSWORD=$TROJAN_GO_PASSWORD
# ⚠️  change this, keep it secret
TROJAN_GO_WS_PATH=$TROJAN_GO_WS_PATH

# gost warp
# ⚠️  change this
GOST_WARP_USERNAME=$GOST_WARP_USERNAME
# ⚠️  change this
GOST_WARP_PASSWORD=$GOST_WARP_PASSWORD
GOST_WARP_PORT=$GOST_WARP_PORT
# ⚠️  change this, keep it secret
GOST_WARP_WS_PATH=$GOST_WARP_WS_PATH
EOF

chmod 600 .env

echo "✅ .env generated"
echo "⚠️  edit .env and fill in passwords before running scripts"
echo "📋 REALITY_PUBLIC_KEY: $REALITY_PUBLIC_KEY (save for client config)"
