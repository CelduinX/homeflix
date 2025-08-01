#!/bin/bash

set -e  # Script bricht bei Fehler ab

echo "🔄 Updating system packages..."
sudo apt update && sudo apt upgrade -y

echo "🐳 Installing Docker..."
# Install prerequisites
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index and install Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "📁 Creating project directories..."
sudo mkdir -p /opt/homeflix/media/{tv,movies,downloads,incomplete} /opt/homeflix/config/{plex,overseerr,radarr,sonarr,sabnzbd}
cd /opt/homeflix
sudo chown -R 1000:1000 ./media ./config
sudo chmod -R 755 ./media ./config

echo "📥 Downloading docker-compose.yml and .env file..."
curl -sSL https://github.com/CelduinX/homeflix/raw/refs/heads/main/docker-compose.yml -o docker-compose.yml
curl -sSL https://github.com/CelduinX/homeflix/raw/refs/heads/main/.env -o .env

echo "📝 Opening .env file for configuration..."
nano .env

if grep -q 'VPN_PRIVATE_KEY=""' .env; then
  echo "⚠️ Please make sure to fill in your VPN credentials in the .env file before starting containers."
  read -p "Press Enter to continue anyway or CTRL+C to cancel..."
fi

echo "📦 Pulling container images..."
docker compose pull

echo "🚀 Starting containers..."
docker compose up -d

echo "✅ Homeflix setup completed!"
