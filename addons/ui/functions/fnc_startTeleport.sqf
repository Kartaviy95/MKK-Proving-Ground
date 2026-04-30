#include "..\script_component.hpp"
/*
    Запускает простой телепорт по клику на карте.
*/
if !(hasInterface) exitWith {};

openMap true;
hint localize "STR_MKK_PTG_SELECT_TELEPORT_POINT";
missionNamespace setVariable ["mkk_ptg_teleportDoneText", localize "STR_MKK_PTG_TELEPORT_DONE"];

onMapSingleClick "
    private _target = vehicle player;
    _target setPosATL [_pos # 0, _pos # 1, 0];
    onMapSingleClick '';
    openMap false;
    hint (missionNamespace getVariable ['mkk_ptg_teleportDoneText', '']);
    true
";
