#!/bin/bash

# Update system
echo "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install required packages
echo "📚 Installing required packages..."
sudo apt-get install -y curl

# Fonksiyon: kubectl kurulumu
install_kubectl() {
  echo "kubectl bulunamadı. kubectl kuruluyor..."

  # En son kararlı sürümü belirle ve indir
  KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
  curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
  
  # İndirdikten sonra çalıştırılabilir yap ve sistem dizinine taşı
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  
  # Geçici dosyayı sil
  rm kubectl
  
  echo "kubectl kurulumu tamamlandı."
}

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

#kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

#kubectl port-forward svc/argocd-server -n argocd 8080:443

#kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo


echo "✅ Installation complete! Please log out and log back in for docker group changes to take effect."

# Verify installations
echo "🔍 Verifying installations..."
docker --version
kubectl version --client
k3d --version
argocd version --client