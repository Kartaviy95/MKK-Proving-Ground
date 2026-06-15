#include "..\script_component.hpp"
/*
    Регистрирует созданную мишень для отдельного удаления.
*/
params [
    ["_entity", objNull]
];

if (isNull _entity) exitWith {};

_entity setVariable ["mkk_ptg_spawnedByPTG", true, true];
_entity setVariable ["mkk_ptg_spawnedKind", "target", true];
_entity setVariable ["mkk_ptg_spawnedAsTarget", true, true];

private _arr = missionNamespace getVariable ["mkk_ptg_spawnedTargets", []];
_arr pushBackUnique _entity;
missionNamespace setVariable ["mkk_ptg_spawnedTargets", _arr, true];
