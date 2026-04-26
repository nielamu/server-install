#!/bin/bash

sudo mkdir -p $XRAY_CONFIG_PATH

cat <<JSON | sudo tee $XRAY_CONFIG_PATH/config.json
{
    "log": {
        "loglevel": "warning"
    },
    "inbounds": [
        {
            "listen": "0.0.0.0",
            "port": $VLESS_REALITY_PORT,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "$VLESS_UUID",
                        "flow": "xtls-rprx-vision"
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "raw",
                "security": "reality",
                "realitySettings": {
                    "show": false,
                    "target": "$REALITY_TARGET",
                    "xver": 0,
                    "serverNames": [
                        "$REALITY_SERVER_NAME"
                    ],
                    "privateKey": "$REALITY_PRIVATE_KEY",
                    "shortIds": [
                        "$REALITY_SHORT_ID"
                    ]
                }
            },
            "sniffing": {
                "enabled": true,
                "destOverride": [
                    "http",
                    "tls",
                    "quic"
                ]
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom",
            "tag": "direct"
        },
        {
            "protocol": "blackhole",
            "tag": "block"
        }
    ]
}
JSON
