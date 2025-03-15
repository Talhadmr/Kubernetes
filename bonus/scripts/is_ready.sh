#!/bin/bash

# 📌 Bu script şunları kontrol edecek:
# ✅ Cluster çalışıyor mu? (kubectl cluster-info ile kontrol edilir)
# ✅ Traefik (veya başka bir Ingress Controller) çalışıyor mu?
# ✅ Gerekli namespace'ler (gitlab, argocd, dev) mevcut mu?
# ✅ ArgoCD ve GitLab servisleri çalışıyor mu?
# ✅ Pod’lar "Running" durumda mı?

# 🚀 Eğer tüm kontroller başarılıysa, ingress.yaml dosyasını deploy edebilirsin.

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔍 Ingress için uygun ortam kontrol ediliyor...${NC}"

# 1️⃣ Kubernetes Cluster Çalışıyor mu?
if kubectl cluster-info > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Kubernetes Cluster çalışıyor.${NC}"
else
    echo -e "${RED}❌ Kubernetes Cluster çalışmıyor! Lütfen kontrol et.${NC}"
    exit 1
fi

# 2️⃣ Ingress Controller (Traefik veya NGINX) Çalışıyor mu?
if kubectl get pods -A | grep -q "traefik"; then
    echo -e "${GREEN}✅ Traefik Ingress Controller çalışıyor.${NC}"
elif kubectl get pods -A | grep -q "ingress-nginx"; then
    echo -e "${GREEN}✅ NGINX Ingress Controller çalışıyor.${NC}"
else
    echo -e "${RED}❌ Ingress Controller çalışmıyor! Lütfen Traefik veya NGINX'i yükle.${NC}"
    exit 1
fi

# 3️⃣ Gerekli Namespace'ler Var mı?
NAMESPACES=("gitlab" "argocd" "dev")
for ns in "${NAMESPACES[@]}"; do
    if kubectl get namespace "$ns" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Namespace '$ns' mevcut.${NC}"
    else
        echo -e "${RED}❌ Namespace '$ns' eksik! Önce oluşturmalısın.${NC}"
        exit 1
    fi
done

# 4️⃣ ArgoCD ve GitLab Servisleri Çalışıyor mu?
SERVICES=(
    "argocd argocd-server"
    "gitlab gitlab-webservice"
)

for svc in "${SERVICES[@]}"; do
    ns=$(echo $svc | awk '{print $1}')
    service=$(echo $svc | awk '{print $2}')
    
    # Servisin tam adını bul (Prefix eşleşmesi)
    found_service=$(kubectl get svc -n "$ns" --no-headers -o custom-columns=":metadata.name" | grep "^$service")

    if [[ -n "$found_service" ]]; then
        echo -e "${GREEN}✅ Servis '$found_service' (namespace: $ns) mevcut.${NC}"
    else
        echo -e "${RED}❌ Servis '$service' (namespace: $ns) bulunamadı! Önce servisin çalıştığından emin ol.${NC}"
        exit 1
    fi
done

# 5️⃣ Pod'lar "Running" veya "Completed" Durumda mı?
pending_pods=$(kubectl get pods -A --no-headers | awk '$4=="Pending" {count++} END {print count+0}') # Pending podları say

if kubectl get pods -A | awk '{print $3}' | grep -E -vq "Running|Completed"; then
    if [[ "$pending_pods" -le 1 ]]; then
        echo -e "${GREEN}✅ Tüm podlar OK.${NC}"
    else
        echo -e "${RED}❌ Çok fazla Pending pod var ($pending_pods adet)! 'kubectl get pods -A' ile kontrol et.${NC}"
        kubectl get pods -A | grep "Pending"
        exit 1
    fi
else
    echo -e "${GREEN}✅ Tüm podlar Running veya Completed durumda.${NC}"
fi



# 🎉 Her şey tamam, Ingress deploy edilebilir
echo -e "${GREEN}🚀 Ingress için uygun ortam hazır! Şimdi 'kubectl apply -f ingress.yaml' çalıştırıyorum...${NC}"

kubectl apply -f /vagrant/confs/argocd-ingress.yaml
kubectl apply -f /vagrant/confs/gitlab-ingress.yaml