#!/bin/bash
sudo apt update
sudo apt install -y curl
curl -sfL https://get.k3s.io | sh -
