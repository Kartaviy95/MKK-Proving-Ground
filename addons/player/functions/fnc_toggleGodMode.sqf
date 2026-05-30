#include "..\script_component.hpp"
/*
    Переключает режим бога для локального игрока.
*/
if !(hasInterface) exitWith {};

private _enabled = !(missionNamespace getVariable ["mkk_ptg_godModeEnabled", false]);
missionNamespace setVariable ["mkk_ptg_godModeEnabled", _enabled];

[player, _enabled] call FUNC(applyGodMode);
