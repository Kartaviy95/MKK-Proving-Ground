#include "..\script_component.hpp"
/*
    Запускает простой телепорт по клику на карте.
*/
if !(hasInterface) exitWith {};

closeDialog 0;
openMap true;
[localize "STR_MKK_PTG_SELECT_TELEPORT_POINT"] call EFUNC(main,showTimedHint);
missionNamespace setVariable ["mkk_ptg_teleportDoneText", localize "STR_MKK_PTG_TELEPORT_DONE"];
missionNamespace setVariable ["mkk_ptg_teleportSelecting", true];

private _marker = missionNamespace getVariable ["mkk_ptg_teleportCurrentPositionMarker", ""];
if (_marker isNotEqualTo "") then {
    deleteMarkerLocal _marker;
};

_marker = format ["mkk_ptg_teleport_current_%1", floor (diag_tickTime * 1000)];
missionNamespace setVariable ["mkk_ptg_teleportCurrentPositionMarker", _marker];

private _target = vehicle player;
private _targetPos = getPos _target;
createMarkerLocal [_marker, _targetPos];
_marker setMarkerShapeLocal "ICON";
_marker setMarkerTypeLocal "mil_start";
_marker setMarkerColorLocal "ColorWEST";
_marker setMarkerTextLocal format [localize "STR_MKK_PTG_TELEPORT_CURRENT_LOCATION", mapGridPosition _targetPos];

onMapSingleClick "
    private _target = vehicle player;
    _target setPosATL [_pos # 0, _pos # 1, 0];
    missionNamespace setVariable ['mkk_ptg_teleportSelecting', false];
    private _marker = missionNamespace getVariable ['mkk_ptg_teleportCurrentPositionMarker', ''];
    if (_marker isNotEqualTo '') then {
        deleteMarkerLocal _marker;
        missionNamespace setVariable ['mkk_ptg_teleportCurrentPositionMarker', ''];
    };
    onMapSingleClick '';
    openMap false;
    [(missionNamespace getVariable ['mkk_ptg_teleportDoneText', ''])] call ptg_main_fnc_showTimedHint;
    true
";

[_marker] spawn {
    params ["_marker"];

    while {
        uiSleep 0.25;
        visibleMap && {missionNamespace getVariable ["mkk_ptg_teleportSelecting", false]}
    } do {
        private _target = vehicle player;
        private _targetPos = getPos _target;
        _marker setMarkerPosLocal _targetPos;
        _marker setMarkerTextLocal format [localize "STR_MKK_PTG_TELEPORT_CURRENT_LOCATION", mapGridPosition _targetPos];
    };

    missionNamespace setVariable ["mkk_ptg_teleportSelecting", false];
    onMapSingleClick "";

    private _activeMarker = missionNamespace getVariable ["mkk_ptg_teleportCurrentPositionMarker", ""];
    if (_activeMarker isEqualTo _marker) then {
        deleteMarkerLocal _marker;
        missionNamespace setVariable ["mkk_ptg_teleportCurrentPositionMarker", ""];
    };
};
