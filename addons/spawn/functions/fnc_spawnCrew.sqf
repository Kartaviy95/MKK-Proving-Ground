#include "..\script_component.hpp"
/*
    Создает штатный экипаж для техники.
*/
if !(isServer) exitWith {};

params [
    ["_vehicle", objNull]
];

if (isNull _vehicle) exitWith {};

createVehicleCrew _vehicle;

{
    _x setVariable ["mkk_ptg_spawnedByPTG", true, true];
    _x setVariable ["mkk_ptg_spawnedCrewParent", _vehicle, true];
    [_x, "object"] call FUNC(registerSpawnedEntity);
} forEach crew _vehicle;
