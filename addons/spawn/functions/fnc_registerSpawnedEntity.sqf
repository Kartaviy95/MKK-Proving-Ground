#include "..\script_component.hpp"
/*
    Регистрирует созданную сущность в серверном реестре полигона.
*/
params [
    ["_entity", objNull],
    ["_kind", "object"]
];

if (isNull _entity) exitWith {};

switch (toLowerANSI _kind) do {
    case "vehicle": {
        private _arr = missionNamespace getVariable ["mkk_ptg_spawnedVehicles", []];
        _arr pushBackUnique _entity;
        missionNamespace setVariable ["mkk_ptg_spawnedVehicles", _arr, true];
    };
    default {
        private _arr = missionNamespace getVariable ["mkk_ptg_spawnedObjects", []];
        _arr pushBackUnique _entity;
        missionNamespace setVariable ["mkk_ptg_spawnedObjects", _arr, true];
    };
};
