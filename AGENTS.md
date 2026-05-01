# AGENTS.md - Codex guidance for MKK Proving Ground

## Token-saving rule
Keep this file short. Do not read every file in `docs/ptg/` by default. Open only the document that is directly relevant to the current task.

## Project identity
- Project: MKK Proving Ground
- Technical name: `mkk_ptg`
- Build prefix: `ptg`
- Target: modular Arma 3 proving ground for vehicle, weapon, projectile, penetration, teleport, and player utility testing.

## Default working rules
- Prefer minimal diffs.
- Work only in files relevant to the requested task.
- Do not reformat unrelated files.
- Do not hardcode mod-specific factions, vehicles, ammo, or UI strings.
- Keep the start menu clean; add large features as separate modules or screens.
- Spawn, delete, and cleanup gameplay objects through the server-side flow.
- Put every user-visible string into `addons/main/stringtable.xml`.
- Support at least English and Russian for visible addon text.
- Use safe fallbacks for missing config values, missing images, and unresolved localized names.

## Module map
- `ptg_main`: internal config, keybinds, UI entry, virtual arsenal, delete object under cursor.
- `ptg_common`: helpers, safe config reads, localization helpers.
- `ptg_catalog`: dynamic `CfgVehicles` catalog, filtering, compatible static ammo boxes.
- `ptg_ui`: dialogs, start menu, vehicle screen, button handlers, object status HUD.
- `ptg_spawn`: server spawn flow and spawned-object registry.
- `ptg_tracking`: projectile tracking.
- `ptg_penetration`: penetration test target, projectile, damage/hitpoint/crew report, ammo parameters.
- `ptg_player`: infinite ammo, god mode, respawn and fired handlers.
- `ptg_player_ace`: ACE medical damage blocking for god mode.
- `ptg_ace`: ACE self actions and terminal actions.

## Read only when relevant
- Product idea, visual style, principles: `docs/ptg/overview.md`
- Dialogs, layout, UX, vehicle card: `docs/ptg/ui-ux.md`
- Dynamic vehicle catalog, filters, spawn, cleanup: `docs/ptg/catalog-and-spawn.md`
- Teleport, tracking, trajectory, markers, status display, penetration test, keybinds, player modes: `docs/ptg/features.md`
- Module boundaries and localization rules: `docs/ptg/architecture-and-localization.md`
- Full original design text, only if the split docs are insufficient: `docs/ptg/design-full.md`

## Before coding
For tasks that touch UI, catalog, spawn, tracking, penetration, player modes, ACE, or localization, read the matching doc above first. Do not read unrelated docs.

## Validation preference
Run the smallest relevant check available. Avoid broad test/build commands unless the task requires them or the user asks for them.
