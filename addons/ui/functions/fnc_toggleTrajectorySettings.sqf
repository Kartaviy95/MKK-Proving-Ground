#include "..\script_component.hpp"
/*
    Opens or closes trajectory line settings popup.
*/
private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if (isNull _display) exitWith {};

private _visible = !(uiNamespace getVariable ["mkk_ptg_trajectorySettingsVisible", false]);
uiNamespace setVariable ["mkk_ptg_trajectorySettingsVisible", _visible];
uiNamespace setVariable ["mkk_ptg_objectStatusSettingsVisible", false];
uiNamespace setVariable ["mkk_ptg_mapProjectileMarkerSettingsVisible", false];

[] call FUNC(updateObjectStatusSettingsMenu);
[] call FUNC(updateMapProjectileMarkerSettingsMenu);
[] call FUNC(updateTrajectorySettingsMenu);
