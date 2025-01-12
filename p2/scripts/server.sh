#!/bin/bash
sudo apt update
sudo apt install -y make
sudo apt install -y curl
curl -sfL https://get.k3s.io | sh -
echo "Updating package index..."
sudo apt-get update -y

echo "Installing required packages for Docker..."
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

echo "Adding Docker GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

echo "Adding Docker repository..."
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

echo "Installing Docker..."
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

echo "Starting Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

echo "Adding vagrant user to Docker group..."
sudo usermod -aG docker vagrant

echo "Docker installation completed!"

# Doğrulama için Docker sürümünü göster
docker --version