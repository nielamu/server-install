#!/bin/bash
# referrer: https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository

# maybe this simple command can do.
sudo curl -fsSL https://get.docker.com | bash -s docker

sudo usermod -aG docker $USER
newgrp docker
