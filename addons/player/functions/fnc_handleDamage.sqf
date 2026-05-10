#include "..\script_component.hpp"
/*
    Блокирует локальный урон игрока, пока включен режим бога.
*/
params [
    ["_unit", objNull, [objNull]],
    ["_selection", "", [""]],
    ["_damage", 0, [0]]
];

if (
    !hasInterface
    || {isNull _unit}
    || {!(_unit getVariable ["mkk_ptg_godModeUnitEnabled", false])}
) exitWith {
    _damage
};

0
