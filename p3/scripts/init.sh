#!/bin/bash

# Update system
echo "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install required packages
echo "📚 Installing required packages..."
sudo apt-get install -y curl

# Install K3s
echo "🚀 Installing K3s..."
curl -sfL https://get.k3s.io | sh -

# Install Docker
if ! command -v docker &> /dev/null; then
    echo "🐳 Docker is not installed. Installing Docker on Debian..."
    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Add user to docker group
    sudo usermod -aG docker $USER
    echo "✅ Docker installation complete. You may need to log out and log back in to use Docker without sudo."
else
    echo "🐳 Docker is already installed."
fi

# Install K3d
echo "🚢 Installing K3d..."
wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# Create K3d cluster
echo "🎯 Creating K3d cluster..."
k3d cluster create mycluster -p "8888:8888@loadbalancer"
# k3d cluster create iot-cluster --api-port 6443 -p 8080:80@loadbalancer --agents 2 --wait


kubectl create namespace argocd
kubectl create namespace dev


# Install Argo CD CLI
echo "🚀 Installing Argo CD CLI..."
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
# kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

echo "✅ Installation complete! Please log out and log back in for docker group changes to take effect."

# Verify installations
echo "🔍 Verifying installations..."
docker --version
kubectl version --client
k3d --version
argocd version --client