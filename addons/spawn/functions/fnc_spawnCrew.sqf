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
