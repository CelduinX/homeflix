#!/bin/bash

set -e  # Exit immediately on error

echo "🔄 Updating system packages..."
apt update && apt upgrade -y

echo "🐳 Installing Docker..."
# Install prerequisites
apt-get install -y ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository (Ubuntu Server only!)
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index and install Docker
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "📁 Creating project directories..."
mkdir -p /opt/homeflix/media/{tv,movies,downloads,incomplete} /opt/homeflix/config/{plex,overseerr,radarr,sonarr,sabnzbd}
cd /opt/homeflix
chown -R 1000:1000 ./media ./config
chmod -R 755 ./media ./config

echo "📥 Downloading docker-compose.yml and .env file..."
curl -sSL https://raw.githubusercontent.com/CelduinX/homeflix/main/docker-compose.yml -o docker-compose.yml
curl -sSL https://raw.githubusercontent.com/CelduinX/homeflix/main/.env -o .env

echo "📦 Pulling container images..."
docker compose pull

echo "📝 Configuration required!"
echo "Your .env file still needs VPN credentials to function correctly."
echo
echo "👉 Please run the following commands manually now:"
echo
echo "   sudo nano /opt/homeflix/.env"
echo
echo "🔐 Edit the VPN_PRIVATE_KEY and other required fields."
echo "🚀 After editing, start Homeflix with:"
echo
echo "   docker compose up -d"
echo
echo "✅ Setup completed. You're now in the Homeflix directory."
cd /opt/homeflix
exec bash  # start interactive shell in /opt/homeflix
