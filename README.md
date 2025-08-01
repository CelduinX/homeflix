# 🎬 Homeflix

Ein selbst gehosteter Docker-Stack für dein Heimkino mit **Plex Media Server** und automatisierter **Usenet-Integration** über Radarr, Sonarr, SABnzbd & mehr.

> **Zielgruppe:** Anfänger, Selbsthoster und Heimkino-Fans, die eine automatisierte Medienverwaltung auf dem eigenen Server möchten.

----------

## 📦 Enthaltene Dienste

Dienst

Beschreibung

**Plex**

Medienserver für Filme, Serien, Musik etc.

**Radarr**

Automatisierter Film-Downloader

**Sonarr**

Automatisierter Serien-Downloader

**Overseerr**

Anfrage-Management für Plex-Nutzer

**SABnzbd**

Usenet-Downloader mit Kategorie-Support

**Gluetun**

VPN-Kill-Switch über WireGuard zur Anonymisierung

----------

## 🌐 Port- und WebUI-Übersicht

Alle Dienste sind im internen Docker-Netzwerk miteinander verbunden.  
Ersetze `<DOCKER_SERVER_IP>` durch die lokale IP deines Docker-Hosts.

Dienst

Port

WebUI URL

Hinweis

Plex

32400

http://<DOCKER_SERVER_IP>:32400

Optional im Router freigeben

Overseerr

5055

http://<DOCKER_SERVER_IP>:5055

Anmeldung beim ersten Start

Radarr

7878

http://<DOCKER_SERVER_IP>:7878

Anmeldung beim ersten Start

Sonarr

8989

http://<DOCKER_SERVER_IP>:8989

Anmeldung beim ersten Start

SABnzbd

8080

http://<DOCKER_SERVER_IP>:8080

Anmeldung beim ersten Start

----------

## 🛠️ Setup-Anleitung

Diese Anleitung gilt für die Standard-Version **ohne Reverse Proxy**.  
Für die Proxy-Variante siehe `docker-compose-proxy.yml` und `.env-proxy`.

### 1. Debian oder Ubuntu Server installieren

Empfohlen: Ubuntu Server 22.04 oder Debian 12

### 2. Docker & Docker Compose installieren

Folge der offiziellen Anleitung:  
[https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/)

### 3. Projektverzeichnis erstellen

sudo mkdir -p /opt/homeflix  
cd /opt/homeflix

### 4. Ordnerstruktur vorbereiten

mkdir -p ./media/{tv,movies,downloads,incomplete} ./config/{plex,overseerr,radarr,sonarr,sabnzbd}  
chown -R 1000:1000 ./media ./config  
chmod -R 755 ./media ./config

### 5. Dateien herunterladen

wget https://raw.githubusercontent.com/<BENUTZERNAME>/homeflix/main/docker-compose.yml  
wget https://raw.githubusercontent.com/<BENUTZERNAME>/homeflix/main/.env

> Passe `<BENUTZERNAME>` an deinen GitHub-Benutzernamen an.

### 6. `.env` Datei anpassen

nano .env

Wichtige Parameter:

-   PUID/PGID → dein Benutzer (z. B. 1000)
    
-   TIMEZONE → z. B. `Europe/Berlin`
    
-   VPN Keys → Konfigurationsdaten deines WireGuard-Anbieters
    
-   Ordnerpfade → belassen oder individuell anpassen
    

### 7. Container starten

docker compose pull  
docker compose up -d

### 8. Überprüfen ob alle Container laufen

docker ps -a

### 9. (Optional) Plex extern verfügbar machen

Leite Port **32400** an deinem Router auf den Server weiter.  
⚠️ Stelle sicher, dass du sichere Authentifizierung bei Plex verwendest.

----------

## 🔐 VPN & Datenschutz

Der Usenet-Traffic über **SABnzbd** läuft ausschließlich durch den Gluetun-VPN-Container.  
Ohne aktive VPN-Verbindung stoppt der Traffic automatisch (Killswitch).  
→ Voraussetzung: Dein VPN-Anbieter muss **WireGuard unterstützen**.

Trage deine Zugangsdaten in der `.env` Datei ein:

VPN_PRIVATE_KEY=...  
VPN_PUBLIC_KEY=...  
VPN_ENDPOINT_IP=...  
VPN_PORT=...

----------

## ⚠️ Live-Logs und Troubleshooting

Die Live-Logs der Container kannst du so anzeigen lassen:

docker compose logs -f plex  
docker compose logs -f sonarr  
docker compose logs -f radarr  
docker compose logs -f overseerr  
docker compose logs -f sabnzbd  
docker compose logs -f gluetun

Alle Logs gleichzeitig:

docker compose logs -f

----------

## 🔁 Backup-Hinweis

Empfohlener Befehl zum Backup des Stacks (ohne MKV-Dateien):

tar --exclude='_.mkv' --exclude='**/_.mkv' -czf homeflix-backup.tar.gz .

----------

## 🔁 Reverse Proxy Variante

Für Nutzer mit einem Reverse Proxy (z. B. NGINX Proxy Manager oder Traefik) gibt es eine eigene Variante:

→ Siehe `docker-compose-proxy.yml` und `.env-proxy`

----------

## ❤️ Danksagung

Homeflix basiert auf großartigen Open-Source-Projekten:

-   linuxserver.io (Plex, Sonarr, Radarr, SABnzbd)
    
-   Gluetun VPN (qdm12/gluetun)
    
-   Overseerr (sct/overseerr)
    
-   Docker
    
-   Allen Entwickler:innen der Docker-Images – vielen Dank! 🙏
    

----------

## 📸 Screenshots

(Screenshots folgen demnächst)

----------

## 📄 Lizenz

Dieses Projekt steht unter der MIT Lizenz.

----------

**Made with ❤️ by Homeflix Community**
