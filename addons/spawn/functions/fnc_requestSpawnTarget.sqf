#include "..\script_component.hpp"
/*
    Клиентский запрос серверного спавна цели.
*/
params [
    ["_mode", "bot"],
    ["_className", ""],
    ["_requestor", objNull],
    ["_distance", 5],
    ["_sector", 50],
    ["_airRadius", 150],
    ["_airHeight", 100]
];

if (_className isEqualTo "") exitWith {};
if (isNull _requestor) exitWith {};
if !([_requestor] call EFUNC(main,isAuthorized)) exitWith {
    [localize "STR_MKK_PTG_NO_ACCESS"] call EFUNC(main,showTimedHint);
};

private _maxDistance = missionNamespace getVariable ["mkk_ptg_spawnMaxDistance", 250];
_distance = (_distance max 1) min _maxDistance;
_sector = (_sector max 5) min 1000;
_airRadius = (_airRadius max 25) min 3000;
_airHeight = (_airHeight max 10) min 2000;

if !(_mode in ["bot", "ground", "air"]) then {_mode = "bot";};
if (_mode isEqualTo "bot" && {!(_className in ["B_Survivor_F", "O_Survivor_F", "I_Survivor_F"])}) exitWith {};
if (_mode isEqualTo "ground" && {!(_className isKindOf "LandVehicle")}) exitWith {};
if (_mode isEqualTo "air" && {!(_className isKindOf "Air")}) exitWith {};

[
    _mode,
    _className,
    _requestor,
    _distance,
    _sector,
    _airRadius,
    _airHeight
] remoteExecCall [QFUNC(serverSpawnTarget), 2];
