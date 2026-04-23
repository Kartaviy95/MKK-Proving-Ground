#include "..\script_component.hpp"
/*
    Создает статичную мишень на сервере.
*/
if !(isServer) exitWith {};

params [
    ["_requestor", objNull]
];

if (isNull _requestor) exitWith {};

private _maxTargets = missionNamespace getVariable ["mkk_ptg_maxTargets", 50];

private _originPos = getPosATL _requestor;
private _spawnPos = _originPos getPos [50, getDir _requestor];

private _target = createVehicle ["TargetP_Inf_Acc2_F", _spawnPos, [], 0, "NONE"];
_target setDir getDir _requestor;

[_target, "target"] call EFUNC(spawn,registerSpawnedEntity);
