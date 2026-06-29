#include "..\script_component.hpp"
/*
    Removes local runtime state for the explosion map surface.
    Explosion result markers stay on the map until the user clears or deletes them.
*/
if !(hasInterface) exitWith {};

private _handlers = missionNamespace getVariable ["mkk_ptg_explosionMapEHs", []];
if (_handlers isNotEqualTo []) then {
    _handlers params [
        ["_display", displayNull, [displayNull]],
        ["_keyDownEH", -1, [0]]
    ];

    if !(isNull _display) then {
        if (_keyDownEH >= 0) then {
            _display displayRemoveEventHandler ["KeyDown", _keyDownEH];
        };
    };
};
missionNamespace setVariable ["mkk_ptg_explosionMapEHs", []];

private _thread = missionNamespace getVariable ["mkk_ptg_explosionCurrentPositionThread", scriptNull];
if !(scriptDone _thread) then {
    terminate _thread;
};
missionNamespace setVariable ["mkk_ptg_explosionCurrentPositionThread", scriptNull];

private _marker = missionNamespace getVariable ["mkk_ptg_explosionCurrentPositionMarker", ""];
if (_marker isNotEqualTo "") then {
    deleteMarkerLocal _marker;
};
missionNamespace setVariable ["mkk_ptg_explosionCurrentPositionMarker", ""];
