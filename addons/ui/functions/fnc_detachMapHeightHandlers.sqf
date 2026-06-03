#include "..\script_component.hpp"
/*
    Снимает локальные обработчики инструмента высоты с текущей карты.
*/
if !(hasInterface) exitWith {};

private _handlers = missionNamespace getVariable ["mkk_ptg_mapHeightMapEHs", []];
if (_handlers isEqualTo []) exitWith {
    missionNamespace setVariable ["mkk_ptg_mapHeightHPressed", false];
};

_handlers params [
    ["_display", displayNull, [displayNull]],
    ["_keyDownEH", -1, [0]],
    ["_keyUpEH", -1, [0]]
];

if !(isNull _display) then {
    if (_keyDownEH >= 0) then {
        _display displayRemoveEventHandler ["KeyDown", _keyDownEH];
    };
    if (_keyUpEH >= 0) then {
        _display displayRemoveEventHandler ["KeyUp", _keyUpEH];
    };
};

missionNamespace setVariable ["mkk_ptg_mapHeightMapEHs", []];
missionNamespace setVariable ["mkk_ptg_mapHeightHPressed", false];
