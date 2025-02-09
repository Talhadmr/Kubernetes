#!/bin/bash

export PATH=/usr/local/bin:$PATH
export KUBECONFIG=$(k3d kubeconfig write bonusCluster)

helm repo add --insecure-skip-tls-verify gitlab https://charts.gitlab.io
helm repo update

kubectl create namespace gitlab
helm install --insecure-skip-tls-verify gitlab gitlab/gitlab -n gitlab -f /vagrant/confs/values.yaml
kubectl wait --for=condition=ready pod --all -n gitlab --timeout=600s

echo "GitLab Root Password: "
kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode
echo

kubectl apply -f /vagrant/confs/ingress.yaml