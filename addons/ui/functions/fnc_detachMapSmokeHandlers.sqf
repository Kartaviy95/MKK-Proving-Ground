#include "..\script_component.hpp"
/*
    Removes the local map smoke handler from the current map display/control.
*/
if !(hasInterface) exitWith {};

private _handlers = missionNamespace getVariable ["mkk_ptg_mapSmokeMapEHs", []];
if (_handlers isEqualTo []) exitWith {};

_handlers params [
    ["_display", displayNull, [displayNull]],
    ["_map", controlNull, [controlNull]],
    ["_handler", -1, [0]],
    ["_handlerType", "mouse", [""]]
];

if (_handler >= 0) then {
    if (_handlerType isEqualTo "key") then {
        if !(isNull _display) then {
            _display displayRemoveEventHandler ["KeyDown", _handler];
        };
    } else {
        if !(isNull _map) then {
            _map ctrlRemoveEventHandler ["MouseButtonDown", _handler];
        };
    };
};

missionNamespace setVariable ["mkk_ptg_mapSmokeMapEHs", []];
