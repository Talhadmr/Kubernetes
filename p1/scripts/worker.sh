#!/bin/bash
sudo apt update
sudo apt install -y curl
export K3S_TOKEN=$(cat /vagrant/agent-token.env)
export K3S_URL="https://192.168.56.110:6443"
#this line is for the worker node to have a static IP
export INSTALL_K3S_EXEC="--node-ip=192.168.56.111"
curl -sfL https://get.k3s.io | sh -
# curl -sfL https://get.k3s.io | K3S_TOKEN=$K3S_TOKEN K3S_URL=$K3S_URL INSTALL_K3S_EXEC="$INSTALL_K3S_EXEC" sh -
rm -f /vagrant/agent-token.env