#include "..\script_component.hpp"
/*
    Переключает текст ammo classname на маркерах projectile из popup настроек.
*/
private _enabled = !(missionNamespace getVariable ["mkk_ptg_mapProjectileMarkerShowAmmo", false]);
missionNamespace setVariable ["mkk_ptg_mapProjectileMarkerShowAmmo", _enabled];

[] call FUNC(updateMapProjectileMarkerSettingsMenu);
