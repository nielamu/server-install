# Across the Great Wall we can reach every corner of the world

## 1. install the infras

```bash
# docker
bash <(wget -qO- https://raw.githubusercontent.com/renxiaoyaoo/server-install/dev/base/docker-install.sh)
# nginx
bash <(wget -qO- https://raw.githubusercontent.com/renxiaoyaoo/server-install/dev/base/nginx-install.sh)
# warp
bash <(wget -qO- https://raw.githubusercontent.com/renxiaoyaoo/server-install/dev/base/warp-cli-install.sh)
# sysctl
bash <(wget -qO- https://raw.githubusercontent.com/renxiaoyaoo/server-install/dev/base/sysctl-setup.sh)
# bbr
bash <(curl -Lso- https://git.io/kernel.sh)
```

## 2. get cert

use Cloudflare DNS or acme.sh, cert should be placed at:
> [my cert](https://github.com/renxiaoyaoo/dotfiles/tree/dev/generate-cert.sh)

```
~/cert/<your-domain>/<your-domain>.pem
~/cert/<your-domain>/<your-domain>.key
```

## 3. generate `.env`

```bash
bash <(wget -qO- https://raw.githubusercontent.com/renxiaoyaoo/server-install/dev/generate-env.sh)
```

edit `.env` and fill in the fields marked with `⚠️`, then load:

```bash
set -a && . ./.env && set +a
```

## 4. run the magic scripts

use docker compose:

```bash
bash <(wget -qO- https://raw.githubusercontent.com/renxiaoyaoo/server-install/dev/docker-compose/install-with-docker-compose.sh)
```

clear containers:

```bash
docker compose down
```
