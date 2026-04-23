#include "..\script_component.hpp"
/*
    Удаляет сущность с полигона.
*/
if !(isServer) exitWith {};

params [
    ["_entity", objNull]
];

if (isNull _entity) exitWith {};

deleteVehicle _entity;
