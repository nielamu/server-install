#!/bin/bash

sudo mkdir -p $HYSTERIA2_CONFIG_PATH

cat <<EOF2 | sudo tee $HYSTERIA2_CONFIG_PATH/config.yaml
listen: :$HYSTERIA2_PORT

tls:
  cert: $CERT_FILE
  key: $KEY_FILE
  sniGuard: strict

auth:
  type: password
  password: $HYSTERIA2_PASSWORD

masquerade:
  type: proxy
  proxy:
    url: $HYSTERIA2_MASQUERADE_URL
    rewriteHost: true
EOF2
