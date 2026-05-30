#include "..\script_component.hpp"
/*
    Отправляет запрос на серверный спавн техники.
*/
params [
    ["_withCrew", false],
    ["_enterAsGunner", false]
];

private _className = missionNamespace getVariable ["mkk_ptg_currentSelection", ""];
if (_className isEqualTo "") exitWith {
    [localize "STR_MKK_PTG_SELECT_VEHICLE_FIRST"] call EFUNC(main,showTimedHint);
};

private _distance = missionNamespace getVariable ["mkk_ptg_spawnDefaultDistance", 10];
private _directionOffset = 0;
private _ammoBoxClass = "";

_distance = parseNumber (uiNamespace getVariable ["mkk_ptg_vehicleDistance", str _distance]);
_directionOffset = parseNumber (uiNamespace getVariable ["mkk_ptg_vehicleDirection", "0"]);

if (_className isKindOf "StaticWeapon") then {
    _ammoBoxClass = missionNamespace getVariable ["mkk_ptg_currentAmmoBoxSelection", ""];
};

[true] call FUNC(saveVehicleSpawnState);

private _driverClass = "";
if (_enterAsGunner) then {
    _driverClass = typeOf player;
};

private _vehicle = [_className, player, _withCrew, _distance, _directionOffset, _ammoBoxClass, _driverClass] call EFUNC(spawn,requestSpawnVehicle);
if (_enterAsGunner) then {
    [_vehicle] call FUNC(startCrewDriverControl);
};
