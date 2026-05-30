#include "..\script_component.hpp"
/*
    Prepares interface size options for the browser dashboard.
*/
private _current = missionNamespace getVariable ["mkk_ptg_hudSize", profileNamespace getVariable ["mkk_ptg_hudSize", 1]];
if !(_current isEqualType 0) then {_current = 1;};

private _options = [
    [0.85, localize "STR_MKK_PTG_INTERFACE_SIZE_SMALL"],
    [1.00, localize "STR_MKK_PTG_INTERFACE_SIZE_NORMAL"],
    [1.15, localize "STR_MKK_PTG_INTERFACE_SIZE_LARGE"],
    [1.30, localize "STR_MKK_PTG_INTERFACE_SIZE_EXTRA_LARGE"]
];

private _rows = [];
{
    _x params ["_value", "_label"];
    _rows pushBack [str (round (_value * 100)), _label, (abs (_current - _value)) < 0.08];
} forEach _options;

uiNamespace setVariable ["mkk_ptg_interfaceSizeOptions", _rows];
