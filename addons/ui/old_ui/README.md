# Old UI Snapshot

This folder keeps the legacy native `MKK_PTG_MainDisplay` layout as a restore
snapshot. It is not included by the active addon config.

To inspect or restore the old layout, compare this file with
`addons/ui/dialogs/provingGround.hpp`. The active UI logic is now backed by the
web display state, so a full rollback may also require restoring the matching
legacy UI handler implementations.

If restoring this snapshot, also restore these legacy stringtable keys into
`addons/main/stringtable.xml`:

```xml
<Key ID="STR_MKK_PTG_DASHBOARD_HINT_MAP_MARKER_AMMO">
    <English>Toggles ammo classname text on projectile map markers.</English>
    <Russian>Включает или выключает classname ammo у маркеров снарядов на карте.</Russian>
    <German>Schaltet den ammo-classname-Text auf Projektilmarkern um.</German>
</Key>
<Key ID="STR_MKK_PTG_DASHBOARD_INFO">
    <English>Workflow: prepare vehicle and targets, enable camera/tracking, analyze trajectories and damage, then clean the range when the test is complete.</English>
    <Russian>Сценарий работы: подготовьте технику и цели, включите камеру/слежение, проанализируйте траектории и повреждения, затем очистите полигон после теста.</Russian>
    <German>Ablauf: Fahrzeuge und Ziele vorbereiten, Kamera/Tracking aktivieren, Flugbahnen und Schaden analysieren, danach das Testgelände räumen.</German>
</Key>
<Key ID="STR_MKK_PTG_REARM_CURRENT_VEHICLE">
    <English>Current vehicle</English>
    <Russian>Текущая техника</Russian>
    <German>Aktuelles Fahrzeug</German>
</Key>
<Key ID="STR_MKK_PTG_REARM_NOTE">
    <English>Select a crew position, weapon/pylon, and compatible magazine. For pylons the list uses getCompatiblePylonMagazines and applies the loadout to the selected pylon.</English>
    <Russian>Выберите место экипажа, оружие/пилон и совместимый магазин. Для пилонов список берётся через getCompatiblePylonMagazines, а выбранный loadout применяется к выбранному пилону.</Russian>
    <German>Wähle Besatzungsposition, Waffe/Pylon und kompatibles Magazin. Für Pylone nutzt die Liste getCompatiblePylonMagazines und wendet das Loadout auf den gewählten Pylon an.</German>
</Key>
```
