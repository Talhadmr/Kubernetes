#!/bin/bash

# Update system
echo "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install required packages
echo "📚 Installing required packages..."
sudo apt-get install -y curl

# kubectl
curl -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" --output /tmp/kubectl
sudo install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl

# Install Docker
if ! command -v docker &> /dev/null; then
    echo "🐳 Docker is not installed. Installing Docker on Debian..."
    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl -y
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

    # Add user to docker group
    sudo usermod -aG docker $USER
    newgrp docker
    echo "✅ Docker installation complete. You may need to log out and log back in to use Docker without sudo."
else
    echo "🐳 Docker is already installed."
fi

# Install K3d
echo "🚢 Installing K3d..."
wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# cluster create
k3d cluster create argocd-p3-cluster

kubectl create namespace argocd
kubectl create namespace dev

# argocd apply
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl wait --for=condition=ready pod --all -n argocd --timeout=300s

# app apply
kubectl apply -n argocd -f manifests/app.yaml
kubectl apply -n dev -f manifests/deployment.yaml
kubectl apply -n dev -f manifests/service.yaml
# kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
echo -n "ArgoCD Admin Password: "
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode
echo

kubectl port-forward svc/argocd-server -n argocd 8080:443