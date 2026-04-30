#include "..\script_component.hpp"
/*
    Помечает локального игрока как использующего бесконечные патроны.
*/
params [
    ["_unit", player, [objNull]],
    ["_enabled", missionNamespace getVariable ["mkk_ptg_infiniteAmmoEnabled", false], [false]]
];

if (!hasInterface || {isNull _unit}) exitWith {};

_unit setVariable ["mkk_ptg_infiniteAmmoUnitEnabled", _enabled];
