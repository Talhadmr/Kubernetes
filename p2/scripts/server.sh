#!/bin/bash
sudo apt update
sudo apt install -y curl
export INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --bind-address=192.168.56.110 --advertise-address=192.168.56.110 --node-ip=192.168.56.110"
curl -sfL https://get.k3s.io | sh -
echo 'alias k="kubectl"' >> /home/vagrant/.bashrc

/usr/local/bin/kubectl apply -f /vagrant/manifest/app1-deployment.yaml
/usr/local/bin/kubectl apply -f /vagrant/manifest/app2-deployment.yaml
/usr/local/bin/kubectl apply -f /vagrant/manifest/app3-deployment.yaml
/usr/local/bin/kubectl apply -f /vagrant/manifest/ingress.yaml