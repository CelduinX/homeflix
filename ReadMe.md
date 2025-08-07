
# 🎬 Homeflix - Automatisierter Plex Heimserver Stack

**Dieser Docker Compose Stack beinhaltet und installeirt alle notwendigen Docker Container für den automatisierten Plex Media Server Betrieb mit Usenet. Dieses Projekt dient nur der einfachen Installation der dafür benötigten Docker Container.**

Eine ausführliche Anleitung der Plex, Overseerr, Radarr, Sonarr und SABnzbd Einrichtung ist nicht enthalten. Entsprechende Anleitungen hierzu sind im Internet zu finden.

## 📚 Inhaltsverzeichnis
- [📦 Enthaltene Dienste](#-enthaltene-dienste)
- [📝 Voraussetzungen](#-voraussetzungen)
- [🌐 Port- und WebUI-Übersicht](#-port--und-webui-übersicht)
- [⚖️ Rechtlicher Hinweis (Disclaimer)](#️-rechtlicher-hinweis-disclaimer)
- [▶️ Option 1: Automatische Installation](#️-option-1-automatische-installation)
- [🛠️ Option 2: Manuelle Installation](#️-option-2-manuelle-installation)
- [🔐 VPN & Datenschutz](#-vpn--datenschutz)
- [⚠️ Live-Logs und Troubleshooting](#️-live-logs-und-troubleshooting)
- [🔁 Backup-Hinweis](#-backup-hinweis)
- [❤️ Danksagung](#️-danksagung)
- [📸 Screenshots](#-screenshots)

## 📦 Enthaltene Dienste:
 - **Plex**: Medienserver für Filme, Serien, Musik etc.
 - **Radarr**: Automatisierter Film-Downloader
 - **Sonarr**: Automatisierter Serien-Downloader
 - **Overseerr**: Anfrage-Management für Plex-Nutzer
 - **SABnzbd**: Usenet-Downloader
 - **Gluetun**: VPN-Kill-Switch über WireGuard

## 📝 Voraussetzungen
- Ubuntu Server (LTS Version empfohlen)
- WireGuard fähiger VPN-Anbieter

## 🌐 Port- und WebUI-Übersicht
Alle Dienste sind im internen Docker-Netzwerk miteinander verbunden.  
Ersetze `<DOCKER_SERVER_IP>` durch die lokale IP deines Docker-Hosts.

| Anwendung| Port | URL |
| :---------------- | ------ | ---- |
|Plex|32400|http://<DOCKER_SERVER_IP>:32400|
|Overseerr|5055|http://<DOCKER_SERVER_IP>:5055|
|Radarr|7878|http://<DOCKER_SERVER_IP>:7878|
|Sonarr|8989|http://<DOCKER_SERVER_IP>:8989|
|SABnzbd|8080|http://<DOCKER_SERVER_IP>:8080|

## ⚖️ Rechtlicher Hinweis (Disclaimer)
Das Herunterladen urheberrechtlich geschützter Inhalte ohne entsprechende Lizenz ist in vielen Ländern, darunter auch Deutschland, **illegal**. Dieses Projekt stellt lediglich eine technische Infrastruktur zur Verfügung, die rechtlich **neutral** ist. Der Betreiber des Servers ist selbst dafür verantwortlich, welche Inhalte über Usenet oder andere Quellen bezogen werden. Bitte informiere dich über die geltenden Gesetze in deinem Land und nutze diese Software ausschließlich für **legale Zwecke**, wie z. B. den Zugriff auf eigene Backups, Open-Source-Medien oder freie Inhalte.

## ▶️ Option 1: Automatische Installation
**1. Script zur automatischen Installation runterladen und ausführen:**

    curl -O https://raw.githubusercontent.com/CelduinX/homeflix/main/autoInstall.sh
    chmod +x autoInstall.sh
    sudo ./autoInstall.sh

 
**2. VPN-Zugangsdaten hinterlegen:**
- Nach der Installation .env-Datei bearbeiten: `nano .env`
- VPN-Zugangsdaten deines VPN-Anbieters hinterlegen
- Abschließend Nano Editor mit `STRG + X` und anschließend `Y` + `Enter` beenden.
- Container mit `docker compose up -d` starten - fertig.

**Hinweis:**
Ohne funktionierende WireGuard VPN-Verbindung sind die Container Radarr, Sonarr und SABnzbd nicht erreichbar!
Die VPN-Verbindung kann über die Log-Ausgabe `docker compose logs -f gluetun` geprüft werden.

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
    wget https://raw.githubusercontent.com/CelduinX/homeflix/main/docker-compose.yml
    wget https://raw.githubusercontent.com/CelduinX/homeflix/main/.env
    sudo chown -R 1000:1000 /opt/homeflix

#### 6. `.env` Datei bearbeiten und VPN-Zugangsdaten hinterlegen:

    nano .env

`VPN_PRIVATE_KEY=""` 
`VPN_ADDRESSES=""` 
`VPN_PUBLIC_KEY=""` 
`VPN_ENDPOINT_IP=""` 

**Wenn kein VPN gewünscht ist verwende die docker-compose.yml und .env Datei aus "withoutVPN"**
*Die Daten können aus der WireGuard conf-Datei des VPN-Anbieters ausgelesen werden.*

**Optional anpassen:**
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

## 🔐 VPN & Datenschutz

Der Internet und Usenet-Traffic über **Radarr, Sonarr** und **SABnzbd** läuft ausschließlich durch den Gluetun-VPN-Container. Ohne aktive VPN-Verbindung stoppt der Traffic automatisch (Killswitch).  
Trage deine Zugangsdaten wie oben beschrieben in der `.env` Datei ein.

## ⚠️ Live-Logs und Troubleshooting

**Die Live-Logs der Container kannst du mit folgenden Befehlen anzeigen lassen:**

    docker compose logs -f plex  
    docker compose logs -f sonarr  
    docker compose logs -f radarr  
    docker compose logs -f overseerr  
    docker compose logs -f sabnzbd  
    docker compose logs -f gluetun

**Alle Logs gleichzeitig:**

    docker compose logs -f

## 🔁 Backup-Hinweis
Der vollständige Docker Stack kann mit folgendem Befehl gesichert werden. Vor allem sinnvoll, wenn alles einmal korrekt konfiguriert wurde. Der Befehl sichert keine Medien mit .mkv oder .avi Dateiendung.

    tar --exclude='*.mkv' --exclude='**/*.mkv' --exclude='*.avi' --exclude='**/*.avi' -czf stack-backup.tar.gz .

## ❤️ Danksagung

**Homeflix basiert auf großartigen Open-Source-Projekten:**
-   linuxserver.io (Plex, Sonarr, Radarr, SABnzbd)   
-   Gluetun VPN (qdm12/gluetun)
-   Overseerr (sct/overseerr)
-   Docker
-   Allen Entwicklern der Docker-Images – vielen Dank! 🙏
    
## 📸 Screenshots

(Screenshots folgen demnächst)
