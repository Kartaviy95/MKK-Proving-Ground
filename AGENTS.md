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
- Keep client-only UI, cameras, HUDs, and draw handlers behind `hasInterface`.
- Keep server authority checks and object creation/removal behind `isServer` or a server `remoteExecCall`.
- Put every user-visible string into `addons/main/stringtable.xml`.
- Support at least English and Russian for visible addon text.
- Use safe fallbacks for missing config values, missing images, and unresolved localized names.
- Treat module READMEs as rough notes; prefer `docs/ptg/*.md` and current code when they disagree.

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
- `extra/intercept`: optional/experimental intercept area; do not make core addons depend on it unless requested.

## Coding patterns
- Add SQF functions as `addons/<module>/functions/fnc_name.sqf` and register them in that module's `XEH_PREP.hpp`.
- Keep each addon in the existing CBA layout: `script_component.hpp`, `XEH_PREP.hpp`, XEH init files, `CfgEventHandlers.hpp`, and `config.cpp`.
- Use existing macros such as `FUNC`, `EFUNC`, `QFUNC`, `GVAR`, and `QGVAR` instead of hand-built function or variable names.
- Store runtime state with the existing `mkk_ptg_` mission/ui namespace keys and clean it on stop: event handlers, cameras, HUD layers, draw handlers, markers, and spawned objects.
- Add remote-callable functions to the relevant config/remote execution surface when needed; do not expose broad remote execution casually.
- Use CBA settings and keybind patterns for configurable behavior. Read setting values with safe defaults.

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
- For localization changes, verify every new `STR_MKK_PTG_*` key has English and Russian text.
- For new SQF functions, verify the file, `XEH_PREP.hpp`, and any call sites use the same function name.
- For UI/HUD changes, verify IDC/layer names are unique within the affected dialog/title.
