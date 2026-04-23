/*
    Создает пехотную цель на сервере.
*/
if !(isServer) exitWith {};

params [
    ["_requestor", objNull]
];

if (isNull _requestor) exitWith {};

private _maxTargets = missionNamespace getVariable ["mkk_ptg_maxTargets", 50];
private _spawnedTargets = missionNamespace getVariable ["mkk_ptg_spawnedTargets", []];
if ((count _spawnedTargets) >= _maxTargets) exitWith {
    ["Лимит мишеней достигнут.", "WARN"] call mkk_ptg_fnc_log;
};

private _originPos = getPosATL _requestor;
private _spawnPos = _originPos getPos [65, getDir _requestor];

private _group = createGroup [east, true];
private _unit = _group createUnit ["O_Soldier_F", _spawnPos, [], 0, "NONE"];
_unit disableAI "PATH";
_unit setDir getDir _requestor;

[_unit, "target"] call mkk_ptg_fnc_registerSpawnedEntity;
