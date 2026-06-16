#include "..\script_component.hpp"
/*
    Создает водителя заданного класса и стороны, затем сажает его в технику.
*/
params [
    ["_vehicle", objNull],
    ["_requestor", objNull],
    ["_driverClass", ""],
    ["_crewSideId", -1]
];

if (isNull _vehicle || {isNull _requestor} || {_driverClass isEqualTo ""}) exitWith {objNull};
if !(isClass (configFile >> "CfgVehicles" >> _driverClass)) exitWith {objNull};
if !(_driverClass isKindOf "CAManBase") exitWith {objNull};
if ((_vehicle emptyPositions "Driver") <= 0) exitWith {objNull};

if !(_crewSideId isEqualType 0) then {
    _crewSideId = parseNumber str _crewSideId;
};
_crewSideId = round _crewSideId;

private _driverSide = switch (_crewSideId) do {
    case 0: {east};
    case 1: {west};
    case 2: {independent};
    default {side _requestor};
};

private _group = createGroup [_driverSide, true];
private _driver = _group createUnit [_driverClass, getPosATL _vehicle, [], 0, "NONE"];
_driver assignAsDriver _vehicle;
_driver moveInDriver _vehicle;

_driver setBehaviour "COMBAT";
_driver setCombatMode "BLUE";
_driver setSpeedMode "FULL";
_driver disableAI "AUTOCOMBAT";
_driver disableAI "AUTOTARGET";
_driver disableAI "TARGET";
_driver enableAI "PATH";

_driver setVariable ["mkk_ptg_spawnedByPTG", true, true];
_driver setVariable ["mkk_ptg_spawnedCrewParent", _vehicle, true];
[_driver, "object"] call FUNC(registerSpawnedEntity);

_driver
