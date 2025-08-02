**Hinweis: Diese Anleitung wurde vom ChatGPT Agenten erstellt und wurde noch nicht getestet!**

---

##  AMD Onboard Transcoding aktivieren (Plex Pass)

**Hinweis:** Diese Anleitung ist nur für **AMD‑iGPU‑Onboard‑Grafikkarten** gedacht (z. B. Ryzen‑APUs mit integrierter Vega‑ oder RDNA‑Grafikeinheit). 

Wenn Medien in Plex nicht über „Direct Play“ abgespielt werden können, müssen sie während der Wiedergabe vom Server in ein passendes Format transkodiert werden. Standardmäßig erledigt das die CPU, was deutlich langsamer und rechenintensiver ist. Durch Aktivieren der Hardware‑Transkodierung nutzt Plex die GPU, wodurch weniger CPU‑Leistung benötigt wird und mehrere Streams möglich sind.

**✅ Voraussetzungen:**
- **Aktiver Plex Pass** (https://www.plex.tv/de/plans/)
- **Kompatible AMD‑iGPU**. Plex bietet Unterstützung für viele AMD‑Grafikkarten lediglich „as is“; die offizielle Testabdeckung ist begrenzt und man empfiehlt eher Intel Quick Sync oder NVIDIA. Neuere Ryzen‑APUs mit VEGA oder RDNA‑Grafikeinheit funktionieren in der Regel.
- **Docker läuft nativ auf dem Host** (kein Virtualisierungs‑Layer wie LXC oder eine VM).
- **Aktueller AMD‑Grafiktreiber und VAAPI‑Bibliotheken** (mesa‑va‑drivers/firmware‑amd‑graphics) müssen auf dem Host installiert sein.
- Dieses Projekt nutzt das **linuxserver/plex‑Image**. Für AMD‑VAAPI benötigt der Container zusätzliche Bibliotheken. Diese stellt das von **jefflessard** bereitgestellte Mod „plex‑vaapi‑amdgpu‑mod“ zur Verfügung.

### ⚙️ 1. `docker‑compose.yml` anpassen
Öffne die `docker‑compose.yml` (z. B. mit `nano docker‑compose.yml`) und navigiere zum **`plex`**‑Service. Füge folgende Zeilen hinzu bzw. ergänze sie:

```
environment:
  - PUID=${PUID}
  - PGID=${PGID}
  - TZ=${TIMEZONE}
  - VERSION=docker
  - PLEX_CLAIM=${PLEX_CLAIM}
  - DOCKER_MODS=jefflessard/plex-vaapi-amdgpu-mod  # VAAPI‑Bibliotheken für AMD
devices:
  - /dev/dri:/dev/dri
```

*`devices`* bindet das VAAPI‑Gerät `/dev/dri` in den Container ein. Die Umgebungsvariable `DOCKER_MODS` lädt das AMD‑VAAPI‑Mod, welches die nötigen Bibliotheken bereitstellt.

Speichere die Datei (`STRG + O`, `Enter`) und beende den Editor (`STRG + X`).

###  2. Docker‑Compose‑Stack neu starten
Damit die Änderungen aktiv werden, starte den Stack neu:

```
docker compose down && docker compose up -d
```

### ️3. Hardware‑Transkodierung in Plex aktivieren
Melde dich im Plex‑Web‑Interface an und navigiere zu **Einstellungen → Server → Transcoder**. Aktiviere:
- **„Hardwarebeschleunigung verwenden, falls verfügbar“**
- **„Hardwarebeschleunigte Video‑Encodierung verwenden“**
- Wähle unter **„Gerät für Hardware‑Transcodierung“** deine AMD‑Grafikkarte aus.

**Wenn deine Grafikkarte in der Auswahlliste erscheint, war die Einrichtung erfolgreich und Plex nutzt ab sofort die GPU zum Transkodieren.**
