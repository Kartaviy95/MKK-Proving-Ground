#include "..\script_component.hpp"
/*
    Toggles ammo classname text on projectile map markers from the settings popup.
*/
private _enabled = !(missionNamespace getVariable ["mkk_ptg_mapProjectileMarkerShowAmmo", false]);
missionNamespace setVariable ["mkk_ptg_mapProjectileMarkerShowAmmo", _enabled];

[] call FUNC(updateMapProjectileMarkerSettingsMenu);
