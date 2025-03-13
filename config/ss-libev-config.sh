#!/bin/bash

sudo mkdir -p $SS_LIBEV_CONFIG_PATH

cat <<EOF | sudo tee $SS_LIBEV_CONFIG_PATH/config.json
{
    "server":["[::0]", "0.0.0.0"],
    "server_port": $SS_LIBEV_PORT,
    "password": "$PASSWORD",
    "timeout": 300,
    "method": "chacha20-ietf-poly1305",
    "fast_open": true,
    "nameserver": "1.1.1.1",
    "mode": "tcp_and_udp",
    "ipv6_first": true,
    "plugin": "v2ray-plugin",
    "plugin_opts": "server;tls;fast-open;cert=$CERT_FILE;key=$KEY_FILE"
}
EOF
