# MKK Proving Ground

A modular Arma 3 proving ground with the technical name `mkk_ptg` and build prefix `ptg`. Current build: `1.3.3.0`, minimum Arma 3 version: `2.20`. The project is designed for quick testing of vehicles, weapons, ammunition, trajectories, penetration, teleportation, and local player utilities.

## Modules

- `ptg_main` - base configuration, keybinds, UI entry point, Virtual/ACE Arsenal, classname copying, deletion and unlocking of the object under the cursor.
- `ptg_common` - shared helpers, safe config reading, English/Russian/German localization, UI/HUD scaling.
- `ptg_catalog` - dynamic `CfgVehicles` catalog, filtering, sorting, vehicle type detection, and compatible ammo box lookup for static weapons.
- `ptg_ui` - main window, start menu, small auxiliary settings windows, vehicle spawn screen, driver+gunner mode, camera, teleport, rearm, test targets, HUD settings, hitpoint inspector, interface scale, and button handlers.
- `ptg_spawn` - global spawning of vehicles, drivers/crews, and test targets, registration of created objects, deletion and range cleanup without requiring the addon to be loaded on a dedicated server.
- `ptg_tracking` - projectile tracking, tracking HUD, trajectory lines, and projectile markers on the map.
- `ptg_penetration` - vehicle penetration test, orbit camera, test projectile, damage/AllowDamage/hitpoints/crew report, and `CfgAmmo` parameters.
- `ptg_player` - infinite ammo, god mode, fired handlers, and respawn handlers.
- `ptg_player_ace` - god mode compatibility with ACE medical damage.
- `ptg_ace` - ACE self-action and ACE actions on terminals.

## Dependencies

- Arma 3 version 2.20 or later.
- CBA_A3.
- ACE3 for the `ptg_ace` and `ptg_player_ace` modules; both modules are marked optional through `skipWhenMissingDependencies` and are skipped if ACE is not loaded.

## Current Features

- clean start menu instead of opening the catalog immediately;
- dynamic vehicle catalog from `CfgVehicles` without hardcoded mod factions;
- filters by side, faction, vehicle type, and search by display name/classname;
- selected vehicle card with image, faction, type, group, crew, and source mod;
- global spawning of empty vehicles, fully crewed vehicles, or vehicles with a player-class driver and the player in a gunner slot;
- vehicle movement control from the gunner slot through native Arma 3 movement actions, including fast forward;
- compatible ammo boxes for static weapons;
- separate test target menu and global target creation/deletion;
- teleport by map click or configurable "Teleport" keybind, T by default;
- free camera: area selection on the map, camera creation at the selected point, WASD/Q/Z/Shift/mouse/wheel controls, temporary speed indicator while scrolling, night vision on N, controls hint on F1, camera relocation by LMB, and closing through a configurable keybind;
- player vehicle rearm: crew/turret position selection, weapon selection, compatible magazine loading, weapon clearing, and pylon handling through `setPylonLoadout`;
- projectile tracking with local camera, HUD for ammo/flight time/distance/mode/speed, timeout, and cooldown;
- trajectory lines with configurable color and thickness;
- projectile markers on the map with an optional ammo classname label;
- object status display on cursor hover with configurable damage/AllowDamage/hitpoints fields;
- hitpoint inspector for the vehicle under the cursor with compact radial cards for total damage and key hitpoints;
- penetration test with vehicle and ammo selection, orbit camera, shot at the selected point, damage report, and ammo classname copying;
- infinite ammo and god mode with reapplication after respawn;
- Virtual Arsenal and ACE3 Arsenal through keybinds;
- classname copying for the object under the cursor;
- object deletion under the cursor with access check and player deletion protection;
- unlocking the vehicle under the cursor;
- interface scale: small, normal, large, extra large;
- visible text localization through `addons/main/stringtable.xml` in English, Russian, and German; the current stringtable contains 300 keys, all with English, Russian, and German entries.

## Documentation

The main up-to-date documents are in `docs/ptg/`:

- `overview.md` - product idea, style, and principles;
- `ui-ux.md` - interface structure, start menu, vehicle screen, camera, rearm, and overlays;
- `catalog-and-spawn.md` - catalog, filters, spawning, ammo boxes, and cleanup;
- `features.md` - teleport, camera, tracking, trajectories, markers, hitpoints, penetration test, access, and settings;
- `architecture-and-localization.md` - modules, dependencies, UI surfaces, gameplay flows, and localization rules;
- `design-full.md` - full original design, use only when the split documents are not enough.

Module README files in `addons/*/README.md` are rough notes; when they differ, prefer `docs/ptg/*.md` and the current code.

## PR Branch Types

- feature/*
- fix/*
- enhancement/*
- optimization/*
- cleanup/*
- change/*
- setting/*
- translation/*

This allows the changelog to be generated automatically.

> [!TIP]
> If PR changes should not appear in the changelog, add the **ignore-changelog** label to the PR.
