#include "..\script_component.hpp"

/*
    Проверяет, была ли сущность создана и помечена runtime PTG.
*/
params [
    ["_entity", objNull, [objNull]]
];

if (isNull _entity) exitWith {false};

(_entity getVariable ["mkk_ptg_spawnedByPTG", false]) isEqualTo true
