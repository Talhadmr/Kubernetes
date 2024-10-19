#!/bin/bash

# .ssh klasörünün içindeki tüm dosyaları sil
echo "Cleaning up the .ssh directory..."
rm -rf ~/.ssh/*

# Yeni bir SSH anahtarı oluştur
echo "Generating new SSH key..."
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""

# Belirtilen dosyayı sil
echo "Removing ~/pro/p1/id_rsa.pub..."
rm -rf ~/pro/p1/id_rsa.pub

# Yeni oluşturulan SSH anahtarını belirtilen dizine kopyala
echo "Copying new id_rsa.pub to ~/pro/p1..."
cp ~/.ssh/id_rsa.pub ~/pro/p1/

echo "Process completed successfully."
