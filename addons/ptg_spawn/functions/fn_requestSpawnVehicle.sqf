/*
    Клиентский запрос серверного спавна.
*/
params [
    ["_className", ""],
    ["_requestor", objNull],
    ["_withCrew", false]
];

if (_className isEqualTo "") exitWith {};
if (isNull _requestor) exitWith {};
if !([_requestor] call mkk_ptg_fnc_isAuthorized) exitWith {
    hint "Нет доступа к полигону.";
};

private _distance = missionNamespace getVariable ["mkk_ptg_spawnDefaultDistance", 30];
private _maxDistance = missionNamespace getVariable ["mkk_ptg_spawnMaxDistance", 250];
_distance = _distance min _maxDistance;

[
    _className,
    _requestor,
    _withCrew,
    _distance
] remoteExecCall ["mkk_ptg_fnc_serverSpawnVehicle", 2];
