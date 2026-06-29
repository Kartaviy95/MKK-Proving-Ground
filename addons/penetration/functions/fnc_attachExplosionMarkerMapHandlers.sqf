#include "..\script_component.hpp"
/*
    Adds Delete-key cleanup for global explosion markers on the regular map.
*/
if !(hasInterface) exitWith {};

private _display = findDisplay 12;
if (isNull _display) then {
    _display = findDisplay 52;
};
if (isNull _display) exitWith {};

private _map = _display displayCtrl 51;
if (isNull _map) exitWith {};

private _handlers = missionNamespace getVariable ["mkk_ptg_explosionMarkerMapEHs", []];
private _attachedDisplay = if (_handlers isEqualTo []) then {displayNull} else {_handlers # 0};
if (_attachedDisplay isEqualTo _display) exitWith {};

[] call FUNC(detachExplosionMarkerMapHandlers);

private _keyDownEH = _display displayAddEventHandler ["KeyDown", {
    params ["_display", "_key", "_shift", "_ctrl", "_alt"];

    if (_key isNotEqualTo DIK_DELETE) exitWith {false};
    if (_shift || {_ctrl} || {_alt}) exitWith {false};

    private _map = _display displayCtrl 51;
    if (isNull _map) exitWith {false};

    [_display, _map, true] call ptg_penetration_fnc_deleteExplosionMarkerAtMapCursor
}];

missionNamespace setVariable ["mkk_ptg_explosionMarkerMapEHs", [_display, _keyDownEH]];
