**Hinweis: Diese Anleitung wurde vom ChatGPT Agenten erstellt und wurde noch nicht getestet!**

---

##  AMD Hardware Transcoding aktivieren (Plex Pass)

**Hinweis:** Diese Anleitung richtet sich an **dedizierte AMD‑Grafikkarten**, die über den PCI‑Express‑Steckplatz angeschlossen sind (z. B. Radeon RX 6000/7000‑Serie). Plex unterstützt AMD‑Grafikkarten nur „as is“; die offizielle Testabdeckung ist gering und die Nutzung erfolgt ohne Garantie.
Wie bei integrierten GPUs müssen Medien, die nicht direkt abgespielt werden können, vom Server in ein passendes Format transkodiert werden. Standardmäßig übernimmt die CPU diese Aufgabe, wodurch Streams ins Stocken geraten können. Mit der Hardware‑Transkodierung nutzt Plex die GPU und entlastet damit die CPU.

**✅ Voraussetzungen:**
- **Plex Pass** (https://www.plex.tv/de/plans/)
- **Kompatible AMD‑Grafikkarte** Video‑Encode/Decode‑Support
- **Aktuelle AMD‑Treiber auf dem Host** (für Ubuntu/Debian z. B. Paket `firmware‑amd‑graphics` bzw. `amdgpu`‑Kernelmodul) und installierte VAAPI/Mesa‑Bibliotheken.
- **Docker läuft nativ** (kein virtualisiertes/LXC Setup). 
- Aktivierung des **plex‑vaapi‑amdgpu‑mods**, um VAAPI‑Bibliotheken innerhalb des Containers bereitzustellen.

### ⚙️ 1. `docker‑compose.yml` bearbeiten
Öffne die `docker‑compose.yml` und gehe zum **`plex`**‑Service. Ergänze die folgenden Zeilen (bzw. passe existierende Einträge an):

```
environment:
  - PUID=${PUID}
  - PGID=${PGID}
  - TZ=${TIMEZONE}
  - VERSION=docker
  - PLEX_CLAIM=${PLEX_CLAIM}
  - DOCKER_MODS=jefflessard/plex-vaapi-amdgpu-mod
devices:
  - /dev/dri:/dev/dri
```

**Tipp:** Solltest du mehrere Grafikkarten betreiben, kannst du mit `sudo lspci` bzw. `ls /dev/dri/by-path` prüfen, welches Gerät zu deiner AMD‑Karte gehört. Durch die Standard‑Einstellung werden alle `/dev/dri`‑Geräte gemountet; bei Problemen kannst du den Pfad zu deinem Gerät explizit angeben (z. B. `/dev/dri/renderD129:/dev/dri/renderD129`).

###  2. Stack neu starten
Speichere die Änderungen und starte den Stack neu:

```
docker compose down && docker compose up -d
```

### ️3. Hardware‑Transkodierung in Plex aktivieren
Öffne das Plex‑Web‑Interface und navigiere zu **Einstellungen → Server → Transcoder**. Aktiviere folgende Optionen:
- **„Hardwarebeschleunigung verwenden, falls verfügbar“**
- **„Hardwarebeschleunigte Video‑Encodierung verwenden“**
- Unter **„Gerät für Hardware‑Transcodierung“** sollte deine AMD‑Grafikkarte auswählbar sein.

**Wenn deine Grafikkarte angezeigt wird und aktivierbar ist, nutzt Plex sie zum Transkodieren deiner Medien.**
