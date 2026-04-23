#include "..\script_component.hpp"
/*
    Удаляет все цели полигона.
*/
if !(isServer) exitWith {};

{
    if !(isNull _x) then {deleteVehicle _x;};
} forEach (missionNamespace getVariable ["mkk_ptg_spawnedTargets", []]);

missionNamespace setVariable ["mkk_ptg_spawnedTargets", []];
