#include "..\script_component.hpp"
/*
    Создает пехотную цель на сервере.
*/

if !(isServer) exitWith {};

params [
    ["_requestor", objNull]
];

if (isNull _requestor) exitWith {};

private _originPos = getPosATL _requestor;
private _spawnPos = _originPos getPos [65, getDir _requestor];

private _group = createGroup [east, true];
private _unit = _group createUnit ["O_Soldier_F", _spawnPos, [], 0, "NONE"];
_unit disableAI "PATH";
_unit setDir getDir _requestor;

[_unit, "target"] call EFUNC(spawn,registerSpawnedEntity);
