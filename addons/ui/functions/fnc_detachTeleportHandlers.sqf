#include "..\script_component.hpp"
/*
    Removes local map handlers used by teleport point selection.
*/
if !(hasInterface) exitWith {};

private _handlers = missionNamespace getVariable ["mkk_ptg_teleportMapEHs", []];
if (_handlers isEqualTo []) exitWith {};

_handlers params [
    ["_display", displayNull, [displayNull]],
    ["_map", controlNull, [controlNull]],
    ["_mouseEH", -1, [0]]
];

if !(isNull _map) then {
    if (_mouseEH >= 0) then {
        _map ctrlRemoveEventHandler ["MouseButtonDown", _mouseEH];
    };
};

missionNamespace setVariable ["mkk_ptg_teleportMapEHs", []];
