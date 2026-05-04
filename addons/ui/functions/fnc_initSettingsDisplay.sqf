#include "..\script_component.hpp"
/*
    Инициализирует отдельное окно дополнительных настроек.
*/
params ["_display"];

disableSerialization;

uiNamespace setVariable ["mkk_ptg_settingsDisplay", _display];
[_display] call EFUNC(common,applyDisplayScale);

private _type = uiNamespace getVariable ["mkk_ptg_settingsDialogType", ""];
switch (_type) do {
    case "objectStatus": {[] call FUNC(updateObjectStatusSettingsMenu)};
    case "mapProjectileMarker": {[] call FUNC(updateMapProjectileMarkerSettingsMenu)};
    case "trajectory": {[] call FUNC(updateTrajectorySettingsMenu)};
    default {[] call FUNC(closeSettingsDialog)};
};
