#include "..\script_component.hpp"
/*
    Регистрирует созданную мишень для отдельного удаления.
*/
params [
    ["_entity", objNull]
];

if (isNull _entity) exitWith {};
private _arr = missionNamespace getVariable ["mkk_ptg_spawnedTargets", []];
_arr pushBackUnique _entity;
missionNamespace setVariable ["mkk_ptg_spawnedTargets", _arr];
