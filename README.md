#### Vagrantfile Konfigürasyonları

#### K3S server modunda yüklemek

#### K3S worker modunda yüklemek

#### K3s cluster yönetimi

#### Temel kubectl komutları

kubectl get pods                  # Pod'ları listele
kubectl get deployments          # Deployment'ları listele 
kubectl get services             # Servisleri listele
kubectl get ingress              # Ingress'leri listele
kubectl apply -f <dosya-adı>     # Yapılandırmayı uygula
kubectl describe ingress         # Ingress detaylarını göster

#### Cluster'ın çalıştığını doğrulamak


#### YAML Konfigürasyonları

- Deployment
- Service
- Ingress


#### K3S vs K3D



wget https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz
tar -xvf k9s_Linux_amd64.tar.gz
sudo mv k9s /usr/local/bin/


k9s --kubeconfig /etc/rancher/k3s/k3s.yaml