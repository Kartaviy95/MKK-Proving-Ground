#include "..\script_component.hpp"
/*
    Полная очистка сущностей полигона на сервере.
*/
if !(isServer) exitWith {};

{
    if !(isNull _x) then {deleteVehicle _x;};
} forEach (missionNamespace getVariable ["mkk_ptg_spawnedVehicles", []]);

{
    if !(isNull _x) then {deleteVehicle _x;};
} forEach (missionNamespace getVariable ["mkk_ptg_spawnedObjects", []]);

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
