#!/bin/bash

sudo apt-get update -y
sudo apt-get install curl -y

if ! command -v docker &> /dev/null; then
    echo "⚠️ Docker is not installed. Installing..."
    sudo apt-get install ca-certificates curl -y
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -y
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
    sudo usermod -aG docker $USER
    newgrp docker
else
    echo "🐳 Docker is already installed."
fi

if ! command -v helm &> /dev/null; then
    echo "⚠️ Helm is not installed. Installing..."
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
else
    echo "✅ Helm is already installed."
fi

if ! command -v kubectl &> /dev/null; then
    echo "⚠️ kubectl is not installed. Installing..."
    curl -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" --output /tmp/kubectl
    sudo install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl
else
    echo "✅ kubectl is already installed."
fi

if ! command -v k9s &> /dev/null; then
    echo "⚠️ k9s is not installed. Installing..."
    wget https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz
    tar -xvf k9s_Linux_amd64.tar.gz
    sudo mv k9s /usr/local/bin/
else
    echo "✅ k9s is already installed."
fi

if ! command -v k3d &> /dev/null; then
    echo "⚠️ k3d is not installed. Installing..."
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | TAG=v5.6.0 bash
else
    echo "✅ k3d is already installed."
fi

k3d cluster create bonusCluster --network host #--k3s-arg "--disable=traefik@server:0" default olarak traefik var bunu disable etmeye ne lüzum var

k3d kubeconfig write bonusCluster
export KUBECONFIG=$(k3d kubeconfig write bonusCluster)
chmod 600 $KUBECONFIG # gereksiz olabilir k3d kubeconfig değerini otomatik set ediyor

sleep 5 # Çok hızlı sonraki komuta geçiyor ve cluster yok ne kontrol etmek istiyorsun diye error basıyor bu sebeple sleep attım
kubectl wait --for=condition=Ready nodes --all --timeout=300s

kubectl create namespace argocd
kubectl create namespace dev

kubectl apply --namespace argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
echo "*****************************************************"
sleep 10
kubectl wait --for=condition=ready pod --all -n argocd --timeout=300s


kubectl apply -n argocd -f ../confs/app.yaml
kubectl apply -n dev -f ../confs/dev/deployment.yaml
kubectl apply -n dev -f ../confs/dev/service.yaml

echo -n "ArgoCD Admin Password: "
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode
echo