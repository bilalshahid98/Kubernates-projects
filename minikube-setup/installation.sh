#!/bin/bash
 
# Exit immediately if a command exits with a non-zero status
set -e
 
# Update the package index
sudo apt install docker.io  -y 
 
 
 
# Add Docker's official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
 
 
# Install Docker Compose
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
sudo curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
 
 
sudo chmod +x /usr/local/bin/docker-compose
# Verify Docker Compose installation
docker compose --version
 
# Add current user to the docker group (optional, for non-root usage)
sudo usermod -aG docker $USER
 
echo "Docker and Docker Compose have been installed successfully!"
echo "Please log out and log back in to apply user group changes."

curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

chmod +x minikube
sudo mv minikube /usr/local/bin/

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x kubectl
sudo mv kubectl /usr/local/bin/

