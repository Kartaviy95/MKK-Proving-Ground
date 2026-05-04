#include "..\script_component.hpp"
/*
    Переключает текст ammo classname на маркерах projectile из окна настроек.
*/
private _enabled = !(missionNamespace getVariable ["mkk_ptg_mapProjectileMarkerShowAmmo", false]);
missionNamespace setVariable ["mkk_ptg_mapProjectileMarkerShowAmmo", _enabled];

if !(isNull (findDisplay 88800)) exitWith {
    [] call FUNC(updateMapProjectileMarkerSettingsMenu);
};

[] call FUNC(updateMapProjectileMarkerSettingsMenu);
