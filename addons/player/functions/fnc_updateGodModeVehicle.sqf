#include "..\script_component.hpp"
/*
    Переносит защиту режима бога между техниками локального игрока.
*/
params [
    ["_unit", player, [objNull]],
    ["_enabled", false, [false]]
];

if (!hasInterface || {isNull _unit}) exitWith {};

private _trackedKey = "mkk_ptg_godModeProtectedVehicle";
private _trackedOwnerKey = "mkk_ptg_godModeProtectedVehicleOwner";
private _trackedVehicle = missionNamespace getVariable [_trackedKey, objNull];
private _trackedOwner = missionNamespace getVariable [_trackedOwnerKey, -1];
private _currentVehicle = vehicle _unit;

if (
    !isNull _trackedVehicle
    && {
        !_enabled
        || {_currentVehicle isEqualTo _unit}
        || {_trackedVehicle isNotEqualTo _currentVehicle}
    }
) then {
    [_trackedVehicle, _unit, false] call FUNC(setVehicleGodMode);
    _trackedVehicle = objNull;
    _trackedOwner = -1;
    missionNamespace setVariable [_trackedKey, objNull];
    missionNamespace setVariable [_trackedOwnerKey, -1];
};

if (!_enabled || {_currentVehicle isEqualTo _unit}) exitWith {};

private _currentOwner = owner _currentVehicle;

if (
    isNull _trackedVehicle
    || {_trackedVehicle isNotEqualTo _currentVehicle}
    || {_trackedOwner isNotEqualTo _currentOwner}
    || {isDamageAllowed _currentVehicle}
) then {
    [_currentVehicle, _unit, true] call FUNC(setVehicleGodMode);
    missionNamespace setVariable [_trackedKey, _currentVehicle];
    missionNamespace setVariable [_trackedOwnerKey, _currentOwner];
};

[_currentVehicle] call FUNC(repairVehicleDamage);
