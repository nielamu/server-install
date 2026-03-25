#!/bin/bash

# referrer: https://hub.docker.com/r/teddysun/shadowsocks-libev
# referrer: https://ss-wiki.htmltomd.com/posts/install-ss-and-v2-by-docker/
# referrer: https://gist.github.com/IvoHu/ea9755d4c4a0e87047d2166521a87560

# create configuration
bash <(wget -qO- https://raw.githubusercontent.com/renxiaoyaoo/server-install/dev/config/ss-libev-config.sh)

sudo docker run \
    -d \
    --name ss-libev \
    --network host \
    --restart=always \
    -v ${CERT_DIR}:${CERT_DIR}:ro \
    -v ${SS_LIBEV_CONFIG_PATH}:${SS_LIBEV_CONFIG_PATH}:ro \
    teddysun/shadowsocks-libev

# docker stop ss-libev && docker rm ss-libev
# docker logs ss-libev -f
