#include "..\script_component.hpp"
/*
    Клиентский запрос серверного спавна.
*/
params [
    ["_className", ""],
    ["_requestor", objNull],
    ["_withCrew", false],
    ["_distance", missionNamespace getVariable ["mkk_ptg_spawnDefaultDistance", 30]],
    ["_directionOffset", 0]
];

if (_className isEqualTo "") exitWith {};
if (isNull _requestor) exitWith {};
if !([_requestor] call EFUNC(main,isAuthorized)) exitWith {
    hint localize "STR_MKK_PTG_NO_ACCESS";
};

private _maxDistance = missionNamespace getVariable ["mkk_ptg_spawnMaxDistance", 250];
_distance = (_distance max 1) min _maxDistance;
_directionOffset = _directionOffset % 360;

[
    _className,
    _requestor,
    _withCrew,
    _distance,
    _directionOffset
] remoteExecCall [QFUNC(serverSpawnVehicle), 2];
