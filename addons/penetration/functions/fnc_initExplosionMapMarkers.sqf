#include "..\script_component.hpp"
/*
    Adds the local player position marker and Delete-key cleanup for global explosion markers.
*/
if !(hasInterface) exitWith {};

params ["_display"];

if (isNull _display) exitWith {};

[] call FUNC(cleanupExplosionMapMarkers);

private _target = vehicle player;
private _marker = format ["mkk_ptg_explosion_current_%1", floor (diag_tickTime * 1000)];
createMarkerLocal [_marker, getPos _target];
_marker setMarkerShapeLocal "ICON";
_marker setMarkerTypeLocal "mil_dot";
_marker setMarkerColorLocal "ColorWEST";
_marker setMarkerSizeLocal [0.45, 0.45];
_marker setMarkerTextLocal localize "STR_MKK_PTG_EXPLOSION_CURRENT_LOCATION";
missionNamespace setVariable ["mkk_ptg_explosionCurrentPositionMarker", _marker];

private _thread = [_marker] spawn {
    params ["_marker"];

    while {
        uiSleep 0.25;
        (missionNamespace getVariable ["mkk_ptg_explosionCurrentPositionMarker", ""]) isEqualTo _marker
        && {!isNull (uiNamespace getVariable ["mkk_ptg_explosionDisplay", displayNull])}
    } do {
        if ((markerType _marker) isEqualTo "") exitWith {
            missionNamespace setVariable ["mkk_ptg_explosionCurrentPositionMarker", ""];
        };

        _marker setMarkerPosLocal (getPos (vehicle player));
    };
};
missionNamespace setVariable ["mkk_ptg_explosionCurrentPositionThread", _thread];

private _keyDownEH = _display displayAddEventHandler ["KeyDown", {
    params ["_display", "_key", "_shift", "_ctrl", "_alt"];

    if (_key isNotEqualTo DIK_DELETE) exitWith {false};
    if (_shift || {_ctrl} || {_alt}) exitWith {false};

    private _map = _display displayCtrl 89040;
    if (isNull _map) exitWith {false};

    [_display, _map, true] call ptg_penetration_fnc_deleteExplosionMarkerAtMapCursor
}];

missionNamespace setVariable ["mkk_ptg_explosionMapEHs", [_display, _keyDownEH]];
