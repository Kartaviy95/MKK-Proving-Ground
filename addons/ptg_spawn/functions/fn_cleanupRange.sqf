/*
    Полная очистка сущностей полигона на сервере.
*/
if !(isServer) exitWith {};

{
    if !(isNull _x) then {deleteVehicle _x;};
} forEach (missionNamespace getVariable ["mkk_ptg_spawnedVehicles", []]);

{
    if !(isNull _x) then {deleteVehicle _x;};
} forEach (missionNamespace getVariable ["mkk_ptg_spawnedTargets", []]);

{
    if !(isNull _x) then {deleteVehicle _x;};
} forEach (missionNamespace getVariable ["mkk_ptg_spawnedObjects", []]);

missionNamespace setVariable ["mkk_ptg_spawnedVehicles", []];
missionNamespace setVariable ["mkk_ptg_spawnedTargets", []];
missionNamespace setVariable ["mkk_ptg_spawnedObjects", []];

["Полигон очищен."] call mkk_ptg_fnc_log;
