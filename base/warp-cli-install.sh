#!/bin/bash
set -euo pipefail

# https://github.com/haoel/haoel.github.io#104-cloudflare-warp-%E5%8E%9F%E7%94%9F-ip
# https://pkg.cloudflareclient.com/

if [[ ! -f /etc/os-release ]]; then
    echo "Unsupported system: /etc/os-release not found"
    exit 1
fi

. /etc/os-release

if [[ "${ID:-}" != "ubuntu" ]]; then
    echo "Unsupported OS: only Ubuntu 22.04, 24.04, 26.04 are supported"
    exit 1
fi

case "${VERSION_ID:-}" in
    "22.04")
        REPO_CODENAME="jammy"
        ;;
    "24.04")
        REPO_CODENAME="noble"
        ;;
    "26.04")
        REPO_CODENAME="resolute"
        ;;
    *)
        echo "Unsupported Ubuntu version: ${VERSION_ID:-unknown}"
        echo "Supported versions: 22.04, 24.04, 26.04"
        exit 1
        ;;
esac

ARCH="$(dpkg --print-architecture)"

# Add cloudflare gpg key
curl https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg

# Add repo
echo "deb [arch=${ARCH} signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ ${REPO_CODENAME} main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list

# Install
sudo apt-get update && sudo apt-get install cloudflare-warp -y

# 清理旧注册
warp-cli registration delete 2>/dev/null || true

# 注册
warp-cli --accept-tos registration new

# 设置 proxy 模式
warp-cli mode proxy

# 设置端口
warp-cli proxy port 40000

# 连接
warp-cli connect

# 等待连接
sleep 3
warp-cli status
echo "success"

# 验证
curl --socks5-hostname 127.0.0.1:40000 https://ipinfo.io

# cat /var/lib/cloudflare-warp/reg.json
# warp-cli settings
# systemctl status warp-svc
# curl -x "socks5://127.0.0.1:40000" ipinfo.io
