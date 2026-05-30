#include "..\script_component.hpp"
/*
    Переключает статус-дисплей объекта под курсором.
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
