**Hinweis: Diese Anleitung wurde vom ChatGPT Agenten erstellt und wurde noch nicht getestet!**

---

##  NVIDIA Hardware Transcoding aktivieren (Plex Pass)

**Hinweis:** Diese Anleitung richtet sich an **dedizierte NVIDIA‑Grafikkarten** (GeForce, Quadro oder Tesla), die über den PCIe‑Slot angeschlossen sind. Bei integrierten NVIDIA‑Lösungen (wie Jetson) gelten teilweise abweichende Anleitungen.

Für Medien, die nicht direkt abgespielt werden können, transkodiert Plex die Dateien während der Wiedergabe.
NVIDIA‑GPUs werden von Plex offiziell unterstützt und sind neben Intel Quick Sync die empfohlene Wahl.

**✅ Voraussetzungen:**
- **Plex Pass** (https://www.plex.tv/de/plans/)
- **Kompatible NVIDIA‑Grafikkarte** mit NVENC/NVDEC‑Unterstützung (GeForce Kepler oder neuer).
  Ab Plex v1.20.2 wird mindestens Treiberversion 450.66 benötigt.
- **Aktuelle NVIDIA‑Treiber** und **nvidia‑container‑toolkit** müssen auf dem Host installiert sein. Folge der Installationsanleitung auf https://github.com/NVIDIA/nvidia-container-toolkit.
- **Docker läuft nativ** (kein LXC/VM).

### ⚙️ 1. `docker‑compose.yml` vorbereiten
Nachdem du die **nvidia‑container‑toolkit** eingerichtet hast, muss der Plex‑Container die NVIDIA‑Runtime verwenden. Öffne die `docker‑compose.yml` und ergänze innerhalb des **`plex`**‑Services Folgendes (bestehende Einträge beibehalten):

```
runtime: nvidia
environment:
  - PUID=${PUID}
  - PGID=${PGID}
  - TZ=${TIMEZONE}
  - VERSION=docker
  - PLEX_CLAIM=${PLEX_CLAIM}
  - NVIDIA_VISIBLE_DEVICES=all
  - NVIDIA_DRIVER_CAPABILITIES=compute,video,utility
```

* `runtime: nvidia` weist Docker an, den NVIDIA‑Container‑Runtime zu verwenden. Laut LinuxServer‑Dokumentation ist dies erforderlich, wenn hardwarebeschleunigte Transkodierung mit NVIDIA genutzt werden soll.
* `NVIDIA_VISIBLE_DEVICES` legt fest, welche GPUs dem Container zur Verfügung stehen. Der Wert `all` macht alle GPUs zugänglich.
* `NVIDIA_DRIVER_CAPABILITIES` definiert, welche Treiber‑Bibliotheken in den Container gemountet werden. Die Optionen `compute`, `video` und `utility` werden für NVENC/NVDEC benötigt.

**Hinweis:** Du musst keinen `/dev/dri`‑Mount setzen – die NVIDIA‑Runtime bindet die GPU und die erforderlichen Bibliotheken automatisch ein.

###  2. Docker‑Compose‑Stack neu starten
Speichere die Änderungen und starte den Plex‑Stack neu:

```
docker compose down && docker compose up -d
```

### ️3. Hardware‑Transkodierung in Plex aktivieren
Navigiere im Plex‑Web‑Interface zu **Einstellungen → Server → Transcoder**. Aktiviere die Optionen:
- **„Hardwarebeschleunigung verwenden, falls verfügbar“**
- **„Hardwarebeschleunigte Video‑Encodierung verwenden“**
- Unter **„Gerät für Hardware‑Transcodierung“** sollte deine NVIDIA‑Grafikkarte (z. B. „NVIDIA GPU 0“) auswählbar sein.

**Wenn die Karte erscheint und ausgewählt werden kann, nutzt Plex ab sofort NVENC/NVDEC zum Transkodieren.**
