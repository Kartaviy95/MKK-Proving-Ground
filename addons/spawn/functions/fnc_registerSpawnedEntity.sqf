#include "..\script_component.hpp"
/*
    Регистрирует созданную сущность в реестре полигона.
*/
params [
    ["_entity", objNull],
    ["_kind", "object"]
];

if (isNull _entity) exitWith {};

_entity setVariable ["mkk_ptg_spawnedByPTG", true, true];
_entity setVariable ["mkk_ptg_spawnedKind", toLowerANSI _kind, true];

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
