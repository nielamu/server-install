#!/bin/bash

# referrer: https://hub.docker.com/r/teddysun/trojan
# referrer: https://github.com/Jrohy/trojan

# create configuration
bash <(wget -qO- https://raw.githubusercontent.com/nielamu/server-install/dev/config/trojan-go-config.sh)

sudo docker run \
    -d \
    --name trojan-go \
    --network host \
    --restart=always \
    -v ${CERT_DIR}:${CERT_DIR}:ro \
    -v ${TROJAN_GO_CONFIG_PATH}:${TROJAN_GO_CONFIG_PATH}:ro \
    teddysun/trojan-go


# docker stop trojan-go && docker rm trojan-go
# docker logs trojan-go -f
