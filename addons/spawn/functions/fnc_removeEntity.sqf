#include "..\script_component.hpp"
/*
    Удаляет сущность с полигона.
*/
params [
    ["_entity", objNull]
];

if (isNull _entity) exitWith {};
if !([_entity] call EFUNC(main,isPTGCreatedEntity)) exitWith {};

deleteVehicle _entity;
