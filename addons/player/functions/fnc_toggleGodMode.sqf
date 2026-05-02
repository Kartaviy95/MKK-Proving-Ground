#include "..\script_component.hpp"
/*
    Переключает режим бога для локального игрока.
*/
if !(hasInterface) exitWith {};

private _enabled = !(missionNamespace getVariable ["mkk_ptg_godModeEnabled", false]);
missionNamespace setVariable ["mkk_ptg_godModeEnabled", _enabled];

[player, _enabled] call FUNC(applyGodMode);

private _status = [localize "STR_MKK_PTG_DISABLED", localize "STR_MKK_PTG_ENABLED"] select _enabled;
[format [localize "STR_MKK_PTG_GOD_MODE_STATUS", _status]] call EFUNC(main,showTimedHint);
