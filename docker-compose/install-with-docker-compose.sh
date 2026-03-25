#!/bin/bash


# create configuration
bash <(wget -qO- https://raw.githubusercontent.com/renxiaoyaoo/server-install/dev/config/ss-libev-config.sh)
bash <(wget -qO- https://raw.githubusercontent.com/renxiaoyaoo/server-install/dev/config/trojan-go-config.sh)

# yaml
wget -N https://raw.githubusercontent.com/renxiaoyaoo/server-install/dev/docker-compose/docker-compose.yml

# docker-compose

docker compose up -d
