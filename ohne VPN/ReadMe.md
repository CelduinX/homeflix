## ▶️ Option 1: Automatische Installation
**1. Script zur automatischen Installation runterladen und ausführen:**

    curl -O https://raw.githubusercontent.com/CelduinX/homeflix/main/ohne%20VPN/autoInstall.sh
    chmod +x autoInstall.sh
    sudo ./autoInstall.sh

 
**2. .env Datei bei Beadrf bearbeiten: (Optional)**
- Nach der Installation .env-Datei bearbeiten: `nano .env`
- Gewünschte Änderungen vornehmen
- Abschließend Nano Editor mit `STRG + X` und anschließend `Y` + `Enter` beenden.
- Container mit `docker compose up -d` starten - fertig.

## 🛠️ Option 2: Manuelle Installation
#### 1. Ubuntu Server installieren
- Ubuntu Server Download: https://ubuntu.com/download/server

#### 2. Docker installieren
Folge der offiziellen Anleitung:  https://docs.docker.com/engine/install/

#### 3. Projektverzeichnis erstellen
    sudo mkdir -p /opt/homeflix
    cd /opt/homeflix

#### 4. Ordnerstruktur vorbereiten
    sudo mkdir -p ./media/{tv,movies,downloads,incomplete} ./config/{plex,overseerr,radarr,sonarr,sabnzbd}  

#### 5. Dateien herunterladen und Berechtigungen anpassen
    wget https://raw.githubusercontent.com/CelduinX/homeflix/main/ohne%20VPN/docker-compose.yml
    wget https://raw.githubusercontent.com/CelduinX/homeflix/main/ohne%20VPN/.env
    sudo chown -R 1000:1000 /opt/homeflix

#### 6. `.env` Datei bei Bedarf bearbeiten und anpassen

    nano .env

- `PUID` und `PGID` 1000 ist die Standard ID für den ersten angelegten Linux User
- `TIMEZONE` für Deutschland: `Europe/Berlin` 
- `PLEX_CLAIM` Claim Code, Plex Server wird beim ersten Start direkt eigenen Plex Konto zugewiesen (optional)
- `PATH_XXXX` Speicherorte der Medien-Dateien
- `XXXX_CONFIG` Speicherorte der Container Configs

#### 7. Container starten
    docker compose pull  
    docker compose up -d

#### 8. Überprüfen ob alle Container laufen
    docker ps -a

#### 9. (Optional) Plex extern verfügbar machen
Leite Port **32400** an deinem Router auf den Server weiter.  

#### 10. Einrichtung von Plex, Overseerr, Radarr, Sonarr und SABnzbd
Abschließend müssen noch Plex, Overseerr, Radarr, Sonarr und SABnzbd eingerichtet werden. 
Anleitungen hierzu findest du im Internet und sind nicht teil dieses Projekts.

## ⚠️ Live-Logs und Troubleshooting

**Die Live-Logs der Container kannst du mit folgenden Befehlen anzeigen lassen:**

    docker compose logs -f plex  
    docker compose logs -f sonarr  
    docker compose logs -f radarr  
    docker compose logs -f overseerr  
    docker compose logs -f sabnzbd

**Alle Logs gleichzeitig:**

    docker compose logs -f

## 🔁 Backup-Hinweis
Der vollständige Docker Stack kann mit folgendem Befehl gesichert werden. Vor allem sinnvoll, wenn alles einmal korrekt konfiguriert wurde. Der Befehl sichert keine Medien mit .mkv oder .avi Dateiendung.

    tar --exclude='*.mkv' --exclude='**/*.mkv' --exclude='*.avi' --exclude='**/*.avi' -czf stack-backup.tar.gz .
