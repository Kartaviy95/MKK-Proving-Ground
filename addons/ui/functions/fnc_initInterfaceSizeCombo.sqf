#include "..\script_component.hpp"
/*
    Заполняет combo размера интерфейса в основном dashboard.
*/
private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if (isNull _display) exitWith {};

private _combo = _display displayCtrl 88131;
if (isNull _combo) exitWith {};

private _current = missionNamespace getVariable ["mkk_ptg_hudSize", profileNamespace getVariable ["mkk_ptg_hudSize", 1]];
if !(_current isEqualType 0) then {_current = 1;};

lbClear _combo;
private _options = [
    [0.85, localize "STR_MKK_PTG_INTERFACE_SIZE_SMALL"],
    [1.00, localize "STR_MKK_PTG_INTERFACE_SIZE_NORMAL"],
    [1.15, localize "STR_MKK_PTG_INTERFACE_SIZE_LARGE"],
    [1.30, localize "STR_MKK_PTG_INTERFACE_SIZE_EXTRA_LARGE"]
];

private _selected = 1;
{
    _x params ["_value", "_label"];
    private _idx = _combo lbAdd _label;
    _combo lbSetValue [_idx, round (_value * 100)];
    if ((abs (_current - _value)) < 0.08) then {_selected = _idx;};
} forEach _options;

_combo lbSetCurSel _selected;
