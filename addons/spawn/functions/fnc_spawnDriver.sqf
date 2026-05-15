#include "..\script_component.hpp"
/*
    Создает водителя заданного класса и сажает его в технику.
*/
params [
    ["_vehicle", objNull],
    ["_requestor", objNull],
    ["_driverClass", ""]
];

if (isNull _vehicle || {isNull _requestor} || {_driverClass isEqualTo ""}) exitWith {objNull};
if !(isClass (configFile >> "CfgVehicles" >> _driverClass)) exitWith {objNull};
if !(_driverClass isKindOf "CAManBase") exitWith {objNull};
if ((_vehicle emptyPositions "Driver") <= 0) exitWith {objNull};

private _group = createGroup [side _requestor, true];
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
