#include "..\script_component.hpp"
/*
    Полная очистка сущностей полигона на сервере.
*/
if !(isServer) exitWith {};

private _spawnedVehicles = (missionNamespace getVariable ["mkk_ptg_spawnedVehicles", []]) select {!isNull _x};
private _spawnedObjects = (missionNamespace getVariable ["mkk_ptg_spawnedObjects", []]) select {!isNull _x};

private _spawnedCrew = allUnits select {
    !(isPlayer _x) && {
        (_x getVariable ["mkk_ptg_spawnedByPTG", false])
        || {(_x getVariable ["mkk_ptg_spawnedCrewParent", objNull]) in _spawnedVehicles}
        || {assignedVehicle _x in _spawnedVehicles}
    }
};

{
    if !(isNull _x) then {deleteVehicle _x;};
} forEach (_spawnedCrew + (_spawnedObjects select {_x isKindOf "Man"}));

{
    if !(isNull _x) then {deleteVehicle _x;};
} forEach (_spawnedObjects select {!(_x isKindOf "Man")});

{
    if !(isNull _x) then {
        {deleteVehicle _x;} forEach crew _x;
        deleteVehicle _x;
    };
} forEach _spawnedVehicles;

{
    if !(isNull _x) then {
        if (_x isKindOf "Man") then {
            deleteVehicle _x;
        } else {
            {deleteVehicle _x;} forEach crew _x;
            deleteVehicle _x;
        };
    };
} forEach (missionNamespace getVariable ["mkk_ptg_spawnedTargets", []]);

missionNamespace setVariable ["mkk_ptg_spawnedTargets", []];
missionNamespace setVariable ["mkk_ptg_spawnedVehicles", []];
missionNamespace setVariable ["mkk_ptg_spawnedObjects", []];
