#!/bin/bash
set -euo pipefail

# allow binding to privileged ports (443) without root
echo 'net.ipv4.ip_unprivileged_port_start=443' | sudo tee /etc/sysctl.d/99-unprivileged-port.conf
sudo sysctl -w net.ipv4.ip_unprivileged_port_start=443

echo "✅ sysctl configured"
