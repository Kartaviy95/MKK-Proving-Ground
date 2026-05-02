#include "..\script_component.hpp"
/*
    Toggles object status display shown for the object under cursor.
*/
if !(hasInterface) exitWith {};

[] call FUNC(registerObjectStatusDisplay);

private _enabled = !(missionNamespace getVariable ["mkk_ptg_objectStatusDisplayEnabled", false]);
missionNamespace setVariable ["mkk_ptg_objectStatusDisplayEnabled", _enabled];

private _layer = "mkk_ptg_objectStatusDisplayLayer" call BIS_fnc_rscLayer;
if (_enabled) then {
    _layer cutRsc ["MKK_PTG_ObjectStatusDisplayHUD", "PLAIN", 0, false];
} else {
    _layer cutText ["", "PLAIN"];
    uiNamespace setVariable ["mkk_ptg_objectStatusDisplayHud", displayNull];
};

private _status = [localize "STR_MKK_PTG_DISABLED", localize "STR_MKK_PTG_ENABLED"] select _enabled;
[format [localize "STR_MKK_PTG_OBJECT_STATUS_DISPLAY_STATUS", _status]] call EFUNC(main,showTimedHint);
