#include "..\script_component.hpp"
/*
    Removes Delete-key cleanup for global explosion markers from the regular map.
*/
if !(hasInterface) exitWith {};

private _handlers = missionNamespace getVariable ["mkk_ptg_explosionMarkerMapEHs", []];
if (_handlers isEqualTo []) exitWith {};

_handlers params [
    ["_display", displayNull, [displayNull]],
    ["_keyDownEH", -1, [0]]
];

if !(isNull _display) then {
    if (_keyDownEH >= 0) then {
        _display displayRemoveEventHandler ["KeyDown", _keyDownEH];
    };
};

missionNamespace setVariable ["mkk_ptg_explosionMarkerMapEHs", []];
