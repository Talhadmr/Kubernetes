#!/bin/bash

sudo apt-get update -y
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

curl -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" --output /tmp/kubectl
sudo install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl

curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | TAG=v5.6.0 bash
k3d cluster create bonusCluster --network host --k3s-arg "--disable=traefik@server:0"

k3d kubeconfig write bonusCluster
export KUBECONFIG=$(k3d kubeconfig write bonusCluster)
chmod 600 $KUBECONFIG

kubectl wait --for=condition=Ready nodes --all --timeout=300s

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx -n kube-system
kubectl wait --namespace kube-system --for=condition=ready pod -l app.kubernetes.io/component=controller --timeout=300s

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl wait --for=condition=ready pod --all -n argocd --timeout=300s

kubectl apply -f /vagrant/confs/app.yaml
kubectl apply -f /vagrant/confs/ingress.yaml

echo -n "ArgoCD Admin Password: "
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode
echo