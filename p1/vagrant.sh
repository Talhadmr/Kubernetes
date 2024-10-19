#!/bin/bash

# Vagrant makinelerini durdur
echo "Halting Vagrant machines..."
vagrant halt

# Vagrant makinelerini etkileşim olmadan sil
echo "Destroying Vagrant machines without confirmation..."
vagrant destroy -f

# .vagrant dizinini sil
echo "Removing .vagrant directory..."
rm -rf .vagrant

# Vagrant ortamını yeniden başlat

