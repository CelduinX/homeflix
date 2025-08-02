**Hinweis: Diese Anleitung wurde vom ChatGPT Agenten erstellt und wurde noch nicht getestet!**

---

##  Intel PCIe‑Grafikkarten (Arc u. ä.) Hardware Transcoding aktivieren (Plex Pass)

    **Hinweis:** Diese Anleitung beschreibt die Aktivierung der Hardware‑Transkodierung für **Intel‑Diskret‑Grafikkarten** wie die **Intel Arc**‑Reihe oder Intel‑Serverkarten. Für integrierte Intel‑Grafikeinheiten (iGPU) gibt es eine separate Anleitung.

    Bei der Wiedergabe von Medien, die nicht per „Direct Play“ kompatibel sind, muss Plex das Video in Echtzeit transkodieren. Durch die Nutzung der **Intel‑Xe‑Medien‑Engine** auf diskreten Karten lassen sich mehrere Streams mit geringerer CPU‑Last realisieren.

    **✅ Voraussetzungen:**
     - **Plex Pass** (https://www.plex.tv/de/plans/)
     - **Intel‑PCIe‑Grafikkarte** mit Unterstützung für die **Xe Media Engine** / Intel Quick Sync Video (z. B. Arc A380, A750, A770). Auf Linux werden Karten ab „Alchemist“ unterstützt.
     - **Aktuelle Intel‑Grafiktreiber und VAAPI‑Pakete** (z. B. `intel-media-va-driver` oder `intel-media-driver`) müssen auf dem Host installiert sein. 
     - **Docker läuft nativ** (keine Virtualisierung), das **linuxserver/plex**‑Image wird verwendet.

    #### ⚙️ 1. `docker‑compose.yml` anpassen
    Die Hardware‑Transkodierung nutzt das Video‑Rendering‑Interface `/dev/dri`. Öffne die `docker‑compose.yml` und ergänze im **`plex`**‑Service folgenden Abschnitt:

```
devices:
  - /dev/dri:/dev/dri
```

    Laut der LinuxServer‑Dokumentation ist das Mounten von `/dev/dri` notwendig, um Hardwarebeschleunigung für Intel‑, AMD‑ und ATI‑Grafikkarten zu nutzen【657662267106317†L445-L450】. Der Container sorgt automatisch dafür, dass der interne Benutzer ausreichende Rechte auf das Gerät erhält.

    Solltest du mehrere Grafikkarten besitzen, musst du keine weiteren Variablen setzen – `/dev/dri` bindet alle verfügbaren Intel‑Rendergeräte ein. Optional kannst du den Pfad zu einer bestimmten Karte angeben (z. B. `/dev/dri/renderD129:/dev/dri/renderD129`).

    ####  2. Stack neu starten
    Speichere die Änderungen und starte den Stack neu:

```
docker compose down && docker compose up -d
```

    #### ️3. Hardware‑Transkodierung in Plex aktivieren
    Öffne das Plex‑Web‑Interface. Wähle **Einstellungen → Server → Transcoder** und aktiviere:
    - **„Hardwarebeschleunigung verwenden, falls verfügbar“**
    - **„Hardwarebeschleunigte Video‑Encodierung verwenden“**
    - Unter **„Gerät für Hardware‑Transcodierung“** sollte deine Intel‑Karte (z. B. „Intel Arc A750“ oder „Intel Graphics“) auftauchen.

    **Sobald das Gerät in der Liste erscheint und aktiviert wurde, nutzt Plex die diskrete Intel‑Grafikkarte zum Transkodieren.**
