#include "..\script_component.hpp"
/*
    Переключает бесконечные патроны для локального игрока.
*/
if !(hasInterface) exitWith {};

private _enabled = !(missionNamespace getVariable ["mkk_ptg_infiniteAmmoEnabled", false]);
missionNamespace setVariable ["mkk_ptg_infiniteAmmoEnabled", _enabled];

[player, _enabled] call FUNC(applyInfiniteAmmo);
