#!/bin/bash

# Docker Hub kullanıcı adınızı buraya yazın
DOCKER_USERNAME="talhadmr"

# App isimleri
APPS=("kub1" "kub2" "kub3")

# Docker build ve push işlemleri
for i in "${!APPS[@]}"; do
  app_name="${APPS[$i]}"
  app_dir="./apps/app$((i + 1))"

  if [ -d "$app_dir" ]; then
    echo "Processing $app_name from $app_dir..."

    # Docker build
    docker build -t "$DOCKER_USERNAME/$app_name:latest" "$app_dir"
    if [ $? -ne 0 ]; then
      echo "Failed to build image for $app_name"
      exit 1
    fi

    # Docker push
    docker push "$DOCKER_USERNAME/$app_name:latest"
    if [ $? -ne 0 ]; then
      echo "Failed to push image for $app_name"
      exit 1
    fi
    echo "Docker image for $app_name pushed successfully."
  else
    echo "Directory $app_dir does not exist. Skipping..."
  fi
done

# Kubernetes apply işlemleri
for manifest_file in ./manifest/*.yaml; do
  echo "Applying $manifest_file..."
  kubectl apply -f "$manifest_file"
  if [ $? -ne 0 ]; then
    echo "Failed to apply manifest $manifest_file"
    exit 1
  fi
done

echo "All apps have been deployed successfully!"
