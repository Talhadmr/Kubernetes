# My Multi-Service Kubernetes App

Bu proje, iki servis içeren bir Node.js uygulamasını Kubernetes üzerinde dağıtmak için hazırlanmıştır.

## Proje Yapısı

- `service1/`: Hello World uygulama dosyaları ve Dockerfile.
- `service2/`: Greeting uygulama dosyaları ve Dockerfile.
- `k8s/`: Kubernetes dağıtım ve servis tanımlamaları.

## Kurulum

1. **Docker İmajlarını Oluşturma**

   Her iki uygulama için dizinlere gidin ve Docker imajlarını oluşturun:

   ```bash
   cd service1
   docker build -t myapp-hello-world:latest .

   cd ../service2
   docker build -t myapp-greeting:latest .
