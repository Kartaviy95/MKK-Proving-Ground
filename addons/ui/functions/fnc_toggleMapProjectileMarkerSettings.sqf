#include "..\script_component.hpp"
/*
    Открывает или закрывает popup настроек маркеров projectile на карте.
*/
private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if (isNull _display) exitWith {};

private _visible = !(uiNamespace getVariable ["mkk_ptg_mapProjectileMarkerSettingsVisible", false]);
uiNamespace setVariable ["mkk_ptg_mapProjectileMarkerSettingsVisible", _visible];
uiNamespace setVariable ["mkk_ptg_objectStatusSettingsVisible", false];
uiNamespace setVariable ["mkk_ptg_trajectorySettingsVisible", false];

[] call FUNC(updateObjectStatusSettingsMenu);
[] call FUNC(updateTrajectorySettingsMenu);
[] call FUNC(updateMapProjectileMarkerSettingsMenu);
