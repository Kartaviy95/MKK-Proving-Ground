#include "..\script_component.hpp"
/*
    Adds the Q map key handler for placing a smoke highlight.
*/
if !(hasInterface) exitWith {};

private _display = findDisplay 12;
if (isNull _display) then {
    _display = findDisplay 52;
};
if (isNull _display) exitWith {};

private _map = _display displayCtrl 51;
if (isNull _map) exitWith {};

private _handlers = missionNamespace getVariable ["mkk_ptg_mapSmokeMapEHs", []];
private _attachedDisplay = if (_handlers isEqualTo []) then {displayNull} else {_handlers # 0};
if (_attachedDisplay isEqualTo _display) exitWith {};

[] call FUNC(detachMapSmokeHandlers);

private _keyEH = _display displayAddEventHandler ["KeyDown", {
    params ["_display", "_key", "_shift", "_ctrl", "_alt"];

    if (_key isNotEqualTo DIK_Q) exitWith {false};
    if (_shift || {_ctrl} || {_alt}) exitWith {false};

    if (missionNamespace getVariable ["mkk_ptg_teleportSelecting", false]) then {
        onMapSingleClick "";
    };

    private _map = _display displayCtrl 51;
    if (isNull _map) exitWith {true};

    private _position = _map ctrlMapScreenToWorld (getMousePosition);
    if ((count _position) < 2) exitWith {true};

    [_position] call ptg_ui_fnc_placeMapSmokeAtPosition;
    true
}];

missionNamespace setVariable ["mkk_ptg_mapSmokeMapEHs", [_display, _map, _keyEH, "key"]];
