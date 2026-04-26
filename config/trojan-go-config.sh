#!/bin/bash

sudo mkdir -p $TROJAN_GO_CONFIG_PATH

cat <<EOF2 | sudo tee $TROJAN_GO_CONFIG_PATH/config.json
{
    "run_type": "server",
    "local_addr": "0.0.0.0",
    "local_port": $TROJAN_GO_PORT,
    "remote_addr": "127.0.0.1",
    "remote_port": 80,
    "password": [
        "$TROJAN_GO_PASSWORD"
    ],
    "ssl": {
        "cert": "$CERT_FILE",
        "key": "$KEY_FILE",
        "cipher": "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384",
        "cipher_tls13": "TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384",
        "prefer_server_cipher": true
    },
    "websocket": {
        "enabled": true,
        "path": "$TROJAN_GO_WS_PATH"
    }
}
EOF2
