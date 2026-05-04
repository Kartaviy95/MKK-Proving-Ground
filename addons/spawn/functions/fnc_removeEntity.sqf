#include "..\script_component.hpp"
/*
    Удаляет сущность с полигона.
*/
params [
    ["_entity", objNull]
];

if (isNull _entity) exitWith {};

deleteVehicle _entity;
