#!/bin/bash
apt-get -y update

# install Docker
apt install docker.io -y

# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Install the Kubernetes CLI
az aks install-cli

# Pull Container Images
docker pull node:13.5-alpine