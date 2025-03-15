#!/bin/bash

export PATH=/usr/local/bin:$PATH
export KUBECONFIG=$(k3d kubeconfig write bonusCluster)

helm repo add --insecure-skip-tls-verify gitlab https://charts.gitlab.io
helm repo update

kubectl get namespace gitlab || kubectl create namespace gitlab

helm install --insecure-skip-tls-verify gitlab gitlab/gitlab --namespace gitlab -f /vagrant/confs/values.yaml
kubectl wait --for=condition=ready pod --all --namespace gitlab --timeout=600s

# GitLab Pod durumlarını kontrol ediyoruz hazır olduğunda ingress çalıştırılacak
echo "GitLab Pod Durumu:"
kubectl get pods -n gitlab

echo -n "GitLab Root Password: "
kubectl get secret gitlab-gitlab-initial-root-password --namespace gitlab -o jsonpath="{.data.password}" | base64 --decode
echo