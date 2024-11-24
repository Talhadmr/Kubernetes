#!/bin/bash
sudo apt update
sudo apt install -y curl
export K3S_TOKEN=$(cat /vagrant/agent-token.env)
export K3S_URL="https://192.168.56.110:6443"
curl -sfL https://get.k3s.io | sh -
rm -f /vagrant/agent-token.env