# MKK Proving Ground

Ein modularer Arma-3-Testplatz mit dem technischen Namen `mkk_ptg` und dem Build-Praefix `ptg`. Aktueller Build: `1.3.3.0`, minimale Arma-3-Version: `2.20`. Das Projekt dient zum schnellen Testen von Fahrzeugen, Waffen, Munition, Flugbahnen, Durchschlag, Teleportation und lokalen Spieler-Werkzeugen.

## Module

- `ptg_main` - Basiskonfiguration, Tastenzuweisungen, UI-Einstieg, Virtual/ACE Arsenal, Kopieren von Classnames, Loeschen und Entsperren des Objekts unter dem Cursor.
- `ptg_common` - gemeinsame Helper, sicheres Lesen von Configs, Lokalisierung auf Englisch/Russisch/Deutsch, UI/HUD-Skalierung.
- `ptg_catalog` - dynamischer `CfgVehicles`-Katalog, Filterung, Sortierung, Erkennung des Fahrzeugtyps und Suche nach kompatiblen Munitionskisten fuer statische Waffen.
- `ptg_ui` - Hauptfenster, Startmenue, kleine Zusatzfenster fuer Einstellungen, Fahrzeug-Erstellungsbildschirm, Fahrer+Schuetze-Modus, Kamera, Teleport, Wiederbewaffnung, Testziele, HUD-Einstellungen, Hitpoint-Inspektor, Interface-Skalierung und Button-Handler.
- `ptg_spawn` - globales Spawnen von Fahrzeugen, Fahrern/Besatzungen und Testzielen, Registrierung erstellter Objekte, Loeschen und Aufraeumen des Testplatzes ohne Pflicht, das Addon auf einem Dedicated Server zu laden.
- `ptg_tracking` - Projectile-Tracking, Tracking-HUD, Flugbahnlinien und Projektilmarker auf der Karte.
- `ptg_penetration` - Fahrzeug-Durchschlagstest, Orbit-Kamera, Testprojektil, Bericht zu damage/AllowDamage/hitpoints/crew und `CfgAmmo`-Parametern.
- `ptg_player` - unendliche Munition, God Mode, Fired-Handler und Respawn-Handler.
- `ptg_player_ace` - Kompatibilitaet des God Mode mit ACE medical damage.
- `ptg_ace` - ACE Self-Action und ACE Actions an Terminals.

## Abhaengigkeiten

- Arma 3 Version 2.20 oder neuer.
- CBA_A3.
- ACE3 fuer die Module `ptg_ace` und `ptg_player_ace`; beide Module sind ueber `skipWhenMissingDependencies` als optional markiert und werden uebersprungen, wenn ACE nicht geladen ist.

## Aktuelle Funktionen

- sauberes Startmenue, statt den Katalog sofort zu oeffnen;
- dynamischer Fahrzeugkatalog aus `CfgVehicles` ohne fest verdrahtete Mod-Fraktionen;
- Filter nach Seite, Fraktion, Fahrzeugtyp und Suche nach Anzeigename/classname;
- Karte des ausgewaehlten Fahrzeugs mit Bild, Fraktion, Typ, Gruppe, Besatzung und Quell-Mod;
- globales Spawnen leerer Fahrzeuge, Fahrzeuge mit voller Besatzung oder Fahrzeuge mit einem Fahrer der Spielerklasse und dem Spieler im Schuetzenplatz;
- Fahrzeugbewegung vom Schuetzenplatz ueber native Arma-3-Bewegungsaktionen inklusive Vollgas;
- kompatible Munitionskisten fuer statische Waffen;
- separates Testzielmenue und globales Erstellen/Loeschen von Zielen;
- Teleport per Kartenklick oder konfigurierbarer Taste "Teleport", standardmaessig T;
- freie Kamera: Bereichsauswahl auf der Karte, Erstellen der Kamera am gewaehlten Punkt, Steuerung mit WASD/Q/Z/Shift/Maus/Mausrad, temporaere Geschwindigkeitsanzeige beim Scrollen, Nachtsicht mit N, Steuerungshinweis mit F1, Verlegen der Kamera per LMB und Schliessen ueber eine konfigurierbare Taste;
- Wiederbewaffnung des Spielerfahrzeugs: Auswahl von Besatzungs-/Turmposition, Waffe, Laden kompatibler Magazine, Entfernen von Waffen und Pylon-Verwaltung ueber `setPylonLoadout`;
- Projectile-Tracking mit lokaler Kamera, HUD fuer ammo/Flugzeit/Distanz/Modus/Geschwindigkeit, Timeout und Cooldown;
- Flugbahnlinien mit konfigurierbarer Farbe und Breite;
- Projektilmarker auf der Karte mit optionaler ammo-classname-Beschriftung;
- Objektstatusanzeige beim Anvisieren mit konfigurierbaren Feldern damage/AllowDamage/hitpoints;
- Hitpoint-Inspektor fuer das Fahrzeug unter dem Cursor mit kompakten Radialkarten fuer Gesamtschaden und wichtige Hitpoints;
- Durchschlagstest mit Auswahl von Fahrzeug und Munition, Orbit-Kamera, Schuss auf den gewaehlten Punkt, Schadensbericht und Kopieren des ammo classname;
- unendliche Munition und God Mode mit erneuter Anwendung nach Respawn;
- Virtual Arsenal und ACE3 Arsenal ueber Tastenzuweisungen;
- Kopieren des Classname des Objekts unter dem Cursor;
- Loeschen des Objekts unter dem Cursor mit Zugriffspruefung und Schutz vor dem Loeschen von Spielern;
- Entsperren des Fahrzeugs unter dem Cursor;
- Interface-Skalierung: small, normal, large, extra large;
- Lokalisierung sichtbarer Texte ueber `addons/main/stringtable.xml` auf Englisch, Russisch und Deutsch; die aktuelle stringtable enthaelt 300 Keys, alle mit English-, Russian- und German-Eintraegen.

## Dokumentation

Die wichtigsten aktuellen Dokumente liegen in `docs/ptg/`:

- `overview.md` - Produktidee, Stil und Prinzipien;
- `ui-ux.md` - Interface-Struktur, Startmenue, Fahrzeugbildschirm, Kamera, Wiederbewaffnung und Overlays;
- `catalog-and-spawn.md` - Katalog, Filter, Spawning, Munitionskisten und Aufraeumen;
- `features.md` - Teleport, Kamera, Tracking, Flugbahnen, Marker, Hitpoints, Durchschlagstest, Zugriff und Einstellungen;
- `architecture-and-localization.md` - Module, Abhaengigkeiten, UI-Oberflaechen, Gameplay-Flows und Lokalisierungsregeln;
- `design-full.md` - vollstaendiges urspruengliches Design, nur verwenden, wenn die aufgeteilten Dokumente nicht ausreichen.

Module-README-Dateien in `addons/*/README.md` sind grobe Notizen; bei Abweichungen haben `docs/ptg/*.md` und der aktuelle Code Vorrang.

## PR-Branch-Typen

- feature/*
- fix/*
- enhancement/*
- optimization/*
- cleanup/*
- change/*
- setting/*
- translation/*

Dadurch kann der Changelog automatisch generiert werden.

> [!TIP]
> Wenn Aenderungen aus einem PR nicht im Changelog erscheinen sollen, fuege dem PR das Label **ignore-changelog** hinzu.
