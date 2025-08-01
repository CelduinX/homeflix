
# 🎬 Homeflix - Automatisierter Plex Heimserver Stack

**Dieser Docker Compose Stack beinhaltet und installeirt alle notwendigen Docker Container für den automatisierten Plex Media Server Betrieb mit Usenet. Dieses Projekt dient nur der einfachen Installation der dafür benötigten Docker Container.**

Wichtig: Eine ausführliche Anleitung, wie Plex, Overseerr, Radarr, Sonarr und SABnzbd eingerichtet werden müssen, ist nicht enthalten. Entsprechende Anleitungen hierzu sind im Internet zu finden.

## 📦 Enthaltene Dienste:
 - **Plex**: Medienserver für Filme, Serien, Musik etc.
 - **Radarr**: Automatisierter Film-Downloader
 - **Sonarr**: Automatisierter Serien-Downloader
 - **Overseerr**: Anfrage-Management für Plex-Nutzer
 - **SABnzbd**: Usenet-Downloader
 - **Gluetun**: VPN-Kill-Switch über WireGuard oder OpenVPN

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
**Führe auf deinen Debian oder Ubuntu Server folgenden Befehl aus:**

    wget
**Bitte lesen! - Wichtiger Hinweis:**
Während der Installation wird der **Nano-Editor** für die Bearbeitung der .env-Datei geöffnet.
Trage hier deine WireGuard VPN-Zugangdaten ein und beende den Nano Editor mit `STRG + X` und anschließend `Y` + `Enter`

Anschließend wird die Installation abgeschlossen und die Container fahren hoch.

## 🛠️ Option 2: Manuelle Installation
#### 1. Debian oder Ubuntu Server installieren
- Ubuntu Server Download: https://ubuntu.com/download/server
- Debian Server Download: https://www.debian.org/distrib/

#### 2. Docker installieren
Folge der offiziellen Anleitung:  https://docs.docker.com/engine/install/

#### 3. Projektverzeichnis erstellen
    sudo mkdir -p /opt/homeflix
    cd /opt/homeflix

#### 4. Ordnerstruktur vorbereiten
    mkdir -p ./media/{tv,movies,downloads,incomplete} ./config/{plex,overseerr,radarr,sonarr,sabnzbd}  
    chown -R 1000:1000 ./media ./config  
    chmod -R 755 ./media ./config

#### 5. Dateien herunterladen
    wget platzhalter/docker-compose.yml  
    wget platzhalter/.env

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
- `HW_TRANSCODE_DEVICE` nur mit Plex-Pass möglich (siehe HardwareTranscoding)
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

Der Internet und Usenet-Traffic über **Radarr, Sonarr** und **SABnzbd** läuft ausschließlich durch den Gluetun-VPN-Container.  
Ohne aktive VPN-Verbindung stoppt der Traffic automatisch (Killswitch).  

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

Kommen noch...

(Screenshots folgen demnächst)
