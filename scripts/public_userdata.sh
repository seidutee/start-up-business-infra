#!/bin/bash
# ------------------------------------------------------------------
# Install Docker and Docker Compose on Amazon Linux 2023
# Tested on: Amazon Linux 2023 (Kernel 6.x)
# ------------------------------------------------------------------

set -e

echo "🚀 Starting Docker installation on Amazon Linux 2023..."

# Step 1: Update system packages
echo "🔄 Updating system packages..."
sudo dnf update -y

# Step 2: Install Docker engine
echo "🐳 Installing Docker Engine..."
sudo dnf install -y docker

# Step 3: Enable and start Docker service
echo "🔧 Enabling and starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

# Step 4: Add current user to the docker group
echo "👤 Adding current user ($USER) to the docker group..."
sudo usermod -aG docker $USER

# Step 5: Install Docker Compose plugin (v2)
echo "🧩 Installing Docker Compose v2 plugin..."
sudo dnf install -y docker-compose-plugin

# Step 6: Verify installation
echo "✅ Verifying Docker installation..."
docker --version
docker compose version

echo "🎉 Docker and Docker Compose have been successfully installed!"
echo ""
echo "📦 Docker service is running. You can test it with:"
echo "    docker run hello-world"
echo ""
echo "⚠️ Note: You may need to log out and back in for group changes to take effect."
echo "------------------------------------------------------------------"
