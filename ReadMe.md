# 🎬 Homeflix - Automatisierter Plex Heimserver Stack
**Dieser Docker Compose Stack beinhaltet und installeirt alle notwendigen Docker Container für den automatisierten Plex Media Server Betrieb mit Usenet. Dieses Projekt dient nur der einfachen Installation der dafür benötigten Docker Container.**
Eine ausführliche Anleitung der Plex, Overseerr, Radarr, Sonarr und SABnzbd Einrichtung ist nicht enthalten. Entsprechende Anleitungen hierzu sind im Internet zu finden.

## Schnellstartanleitung - Wähle deine Variante:
 - **Docker Stack mit WireGuard VPN:** https://github.com/CelduinX/homeflix/tree/main/WireGuard%20VPN
 - **Docker Stack mit OpenVPN:** https://github.com/CelduinX/homeflix/tree/main/OpenVPN
 - **Docker Stack ohne VPN:** https://github.com/CelduinX/homeflix/tree/main/ohne%20VPN

## 📦 Enthaltene Dienste:
 - **Plex**: Medienserver für Filme, Serien, Musik etc.
 - **Radarr**: Automatisierter Film-Downloader
 - **Sonarr**: Automatisierter Serien-Downloader
 - **Overseerr**: Anfrage-Management für Plex-Nutzer
 - **SABnzbd**: Usenet-Downloader
 - **Gluetun**: VPN-Kill-Switch über WireGuard

## 📝 Voraussetzungen
- Ubuntu Server (LTS Version empfohlen)
- WireGuard/OpenVPN fähiger VPN-Anbieter wenn mit VPN gewünscht

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

## ❤️ Danksagung

**Homeflix basiert auf großartigen Open-Source-Projekten:**
-   linuxserver.io (Plex, Sonarr, Radarr, SABnzbd)   
-   Gluetun VPN (qdm12/gluetun)
-   Overseerr (sct/overseerr)
-   Docker
-   Allen Entwicklern der Docker-Images – vielen Dank! 🙏
