#include "..\script_component.hpp"
/*
    Запускает простой телепорт по клику на карте.
*/
if !(hasInterface) exitWith {};

closeDialog 0;
openMap true;
[localize "STR_MKK_PTG_SELECT_TELEPORT_POINT"] call EFUNC(main,showTimedHint);
missionNamespace setVariable ["mkk_ptg_teleportDoneText", localize "STR_MKK_PTG_TELEPORT_DONE"];

onMapSingleClick "
    private _target = vehicle player;
    _target setPosATL [_pos # 0, _pos # 1, 0];
    onMapSingleClick '';
    openMap false;
    [(missionNamespace getVariable ['mkk_ptg_teleportDoneText', ''])] call ptg_main_fnc_showTimedHint;
    true
";
