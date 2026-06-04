#include "..\script_component.hpp"
/*
    Запускает простой телепорт по клику на карте.
*/
if !(hasInterface) exitWith {};

[] call FUNC(detachTeleportHandlers);
onMapSingleClick "";

if (missionNamespace getVariable ["mkk_ptg_teleportTemporaryMap", false]) then {
    player unlinkItem "ItemMap";
    missionNamespace setVariable ["mkk_ptg_teleportTemporaryMap", false];
};

private _hasMap = "ItemMap" in assignedItems player;
if !(_hasMap) then {
    player linkItem "ItemMap";
};
missionNamespace setVariable ["mkk_ptg_teleportTemporaryMap", !_hasMap];

uiNamespace setVariable ["mkk_ptg_mainDisplayClosing", true];
uiNamespace setVariable ["mkk_ptg_webReady", false];
closeDialog 0;
openMap true;
[localize "STR_MKK_PTG_SELECT_TELEPORT_POINT"] call EFUNC(main,showTimedHint);
missionNamespace setVariable ["mkk_ptg_teleportSelecting", true];

private _teleportToken = format ["%1_%2", diag_tickTime, floor (random 1000000)];
missionNamespace setVariable ["mkk_ptg_teleportSelectionToken", _teleportToken];

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

[] spawn {
    waitUntil {
        uiSleep 0.01;
        !(missionNamespace getVariable ["mkk_ptg_teleportSelecting", false]) || {!isNull (findDisplay 12)} || {!isNull (findDisplay 52)}
    };

    if !(missionNamespace getVariable ["mkk_ptg_teleportSelecting", false]) exitWith {};

    private _display = findDisplay 12;
    if (isNull _display) then {
        _display = findDisplay 52;
    };
    if (isNull _display) exitWith {};

    private _map = _display displayCtrl 51;
    if (isNull _map) exitWith {};

    [] call ptg_ui_fnc_detachTeleportHandlers;

    private _mouseEH = _map ctrlAddEventHandler ["MouseButtonDown", {
        params ["_control", "_button", "_x", "_y", "_shift", "_ctrl", "_alt"];

        if !(missionNamespace getVariable ["mkk_ptg_teleportSelecting", false]) exitWith {false};
        if (_button isNotEqualTo 0) exitWith {false};
        if (_shift || {_ctrl} || {_alt}) exitWith {false};

        private _pos = _control ctrlMapScreenToWorld [_x, _y];
        if ((count _pos) < 2) exitWith {true};

        private _token = missionNamespace getVariable ["mkk_ptg_teleportSelectionToken", ""];
        private _result = [_pos, _token] call ptg_ui_fnc_applyTeleport;
        if ((_result # 0) isEqualTo false) exitWith {
            [_result # 1] call ptg_main_fnc_showTimedHint;
            true
        };

        missionNamespace setVariable ["mkk_ptg_teleportSelecting", false];
        missionNamespace setVariable ["mkk_ptg_teleportSelectionToken", ""];
        [] call ptg_ui_fnc_detachTeleportHandlers;

        private _marker = missionNamespace getVariable ["mkk_ptg_teleportCurrentPositionMarker", ""];
        if (_marker isNotEqualTo "") then {
            deleteMarkerLocal _marker;
            missionNamespace setVariable ["mkk_ptg_teleportCurrentPositionMarker", ""];
        };

        onMapSingleClick "";
        openMap false;
        if (missionNamespace getVariable ["mkk_ptg_teleportTemporaryMap", false]) then {
            player unlinkItem "ItemMap";
            missionNamespace setVariable ["mkk_ptg_teleportTemporaryMap", false];
        };

        [_result # 1] call ptg_main_fnc_showTimedHint;
        true
    }];

    missionNamespace setVariable ["mkk_ptg_teleportMapEHs", [_display, _map, _mouseEH]];
};

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
    missionNamespace setVariable ["mkk_ptg_teleportSelectionToken", ""];
    [] call ptg_ui_fnc_detachTeleportHandlers;
    onMapSingleClick "";

    if (missionNamespace getVariable ["mkk_ptg_teleportTemporaryMap", false]) then {
        player unlinkItem "ItemMap";
        missionNamespace setVariable ["mkk_ptg_teleportTemporaryMap", false];
    };

    private _activeMarker = missionNamespace getVariable ["mkk_ptg_teleportCurrentPositionMarker", ""];
    if (_activeMarker isEqualTo _marker) then {
        deleteMarkerLocal _marker;
        missionNamespace setVariable ["mkk_ptg_teleportCurrentPositionMarker", ""];
    };
};
