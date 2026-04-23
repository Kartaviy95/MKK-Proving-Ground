#include "..\script_component.hpp"
/*
    Регистрирует созданную сущность в серверном реестре полигона.
*/
if !(isServer) exitWith {};

params [
    ["_entity", objNull],
    ["_kind", "object"]
];

if (isNull _entity) exitWith {};

switch (toLowerANSI _kind) do {
    case "vehicle": {
        private _arr = missionNamespace getVariable ["mkk_ptg_spawnedVehicles", []];
        _arr pushBackUnique _entity;
        missionNamespace setVariable ["mkk_ptg_spawnedVehicles", _arr];
    };
    case "target": {
        private _arr = missionNamespace getVariable ["mkk_ptg_spawnedTargets", []];
        _arr pushBackUnique _entity;
        missionNamespace setVariable ["mkk_ptg_spawnedTargets", _arr];
    };
    default {
        private _arr = missionNamespace getVariable ["mkk_ptg_spawnedObjects", []];
        _arr pushBackUnique _entity;
        missionNamespace setVariable ["mkk_ptg_spawnedObjects", _arr];
    };
};
