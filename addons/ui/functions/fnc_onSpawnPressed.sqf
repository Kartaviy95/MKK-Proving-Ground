#include "..\script_component.hpp"
/*
    Отправляет запрос на серверный спавн техники.
*/
params [
    ["_withCrew", false]
];

private _className = missionNamespace getVariable ["mkk_ptg_currentSelection", ""];
if (_className isEqualTo "") exitWith {
    hint localize "STR_MKK_PTG_SELECT_VEHICLE_FIRST";
};

private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
private _distance = missionNamespace getVariable ["mkk_ptg_spawnDefaultDistance", 30];
private _directionOffset = 0;

if !(isNull _display) then {
    _distance = parseNumber ctrlText (_display displayCtrl 88015);
    _directionOffset = parseNumber ctrlText (_display displayCtrl 88016);
};

[_className, player, _withCrew, _distance, _directionOffset] call EFUNC(spawn,requestSpawnVehicle);
