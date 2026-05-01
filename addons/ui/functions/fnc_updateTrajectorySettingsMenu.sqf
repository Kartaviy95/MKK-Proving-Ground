#include "..\script_component.hpp"
/*
    Refreshes the centered popup for trajectory line settings.
*/
disableSerialization;

private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];

private _fncDestroyPopup = {
    private _controls = uiNamespace getVariable ["mkk_ptg_trajectorySettingsControls", []];
    {
        if (!isNull _x) then {
            ctrlDelete _x;
        };
    } forEach _controls;

    uiNamespace setVariable ["mkk_ptg_trajectorySettingsControls", []];
};

call _fncDestroyPopup;

if (isNull _display) exitWith {};
if !(uiNamespace getVariable ["mkk_ptg_trajectorySettingsVisible", false]) exitWith {
    [] call FUNC(setDashboardControlsBlocked);
};

private _allControls = [];
private _panelX = 0.31;
private _panelY = 0.10;
private _panelW = 0.38;
private _panelH = 0.75;
private _pad = 0.018;
private _rowH = 0.038;
private _rowGap = 0.010;
private _colorSize = 0.024;

private _fncCreateCtrl = {
    params ["_className", "_pos", ["_bgColor", [0, 0, 0, 0]]];

    private _ctrl = _display ctrlCreate [_className, -1];
    _ctrl ctrlSetPosition _pos;
    _ctrl ctrlSetBackgroundColor _bgColor;
    _ctrl ctrlCommit 0;
    _allControls pushBack _ctrl;

    _ctrl
};

private _backdrop = ["MKK_PTG_RscButton", [0.05, 0.05, 0.90, 0.85], [0.00, 0.00, 0.00, 0.46]] call _fncCreateCtrl;
_backdrop ctrlSetText "";
_backdrop ctrlSetEventHandler ["ButtonClick", format ["uiNamespace setVariable ['mkk_ptg_trajectorySettingsVisible', false]; [] call %1", QFUNC(updateTrajectorySettingsMenu)]];

["MKK_PTG_RscText", [_panelX, _panelY, _panelW, _panelH], [0.010, 0.016, 0.022, 0.985]] call _fncCreateCtrl;
["MKK_PTG_RscText", [_panelX, _panelY, _panelW, 0.004], [0.10, 0.72, 0.92, 0.95]] call _fncCreateCtrl;
["MKK_PTG_RscText", [_panelX, _panelY, 0.004, _panelH], [0.10, 0.72, 0.92, 0.95]] call _fncCreateCtrl;

private _title = ["MKK_PTG_RscText", [_panelX + _pad, _panelY + 0.016, _panelW - (_pad * 2), 0.034]] call _fncCreateCtrl;
_title ctrlSetText localize "STR_MKK_PTG_TRAJECTORY_SETTINGS";
_title ctrlSetTextColor [0.72, 0.88, 1, 1];

private _curY = _panelY + 0.065;

private _fncCreateSection = {
    params ["_text"];

    private _ctrl = ["MKK_PTG_RscText", [_panelX + _pad, _curY, _panelW - (_pad * 2), 0.026]] call _fncCreateCtrl;
    _ctrl ctrlSetText _text;
    _ctrl ctrlSetTextColor [0.72, 0.88, 1, 1];
    _curY = _curY + 0.032;
};

private _colorIndex = missionNamespace getVariable ["mkk_ptg_trajectoryColorIndex", 0];
private _colors = [
    [localize "STR_MKK_PTG_COLOR_CYAN", [0.10, 0.85, 1.00, 1.00]],
    [localize "STR_MKK_PTG_COLOR_RED", [1.00, 0.00, 0.00, 1.00]],
    [localize "STR_MKK_PTG_COLOR_YELLOW", [1.00, 1.00, 0.00, 1.00]],
    [localize "STR_MKK_PTG_COLOR_GREEN", [0.20, 1.00, 0.25, 1.00]],
    [localize "STR_MKK_PTG_COLOR_MAGENTA", [1.00, 0.00, 1.00, 1.00]],
    [localize "STR_MKK_PTG_COLOR_WHITE", [1.00, 1.00, 1.00, 1.00]]
];

[localize "STR_MKK_PTG_COLOR"] call _fncCreateSection;
{
    private _idx = _forEachIndex;
    _x params ["_label", "_color"];
    private _selected = _idx == _colorIndex;
    private _rowColor = [[0.045, 0.055, 0.070, 0.96], [0.060, 0.110, 0.145, 0.96]] select _selected;
    private _event = format ["[%1] call %2", _idx, QFUNC(setTrajectoryColor)];

    private _row = ["MKK_PTG_RscButton", [_panelX + _pad, _curY, _panelW - (_pad * 2), _rowH], _rowColor] call _fncCreateCtrl;
    _row ctrlSetText "";
    _row ctrlSetEventHandler ["ButtonClick", _event];

    ["MKK_PTG_RscText", [_panelX + _pad + 0.010, _curY + ((_rowH - _colorSize) / 2), _colorSize, _colorSize], _color] call _fncCreateCtrl;

    private _labelCtrl = ["MKK_PTG_RscText", [_panelX + _pad + 0.044, _curY + 0.005, _panelW - (_pad * 2) - 0.058, _rowH - 0.006]] call _fncCreateCtrl;
    _labelCtrl ctrlSetText (["", "> "] select _selected) + _label;
    _labelCtrl ctrlSetTextColor ([[0.78, 0.86, 0.90, 1], [1, 1, 1, 1]] select _selected);

    _curY = _curY + _rowH + _rowGap;
} forEach _colors;

private _width = missionNamespace getVariable ["mkk_ptg_trajectoryLineWidth", 3];
private _widths = [1, 2, 3, 5, 8];
_curY = _curY + 0.008;
[localize "STR_MKK_PTG_LINE_WIDTH"] call _fncCreateSection;
{
    private _selected = _x == _width;
    private _rowColor = [[0.045, 0.055, 0.070, 0.96], [0.060, 0.110, 0.145, 0.96]] select _selected;
    private _event = format ["[%1] call %2", _x, QFUNC(setTrajectoryWidth)];

    private _row = ["MKK_PTG_RscButton", [_panelX + _pad, _curY, _panelW - (_pad * 2), _rowH], _rowColor] call _fncCreateCtrl;
    _row ctrlSetText format ["%1%2", ["", "> "] select _selected, format [localize "STR_MKK_PTG_LINE_WIDTH_VALUE", _x]];
    _row ctrlSetEventHandler ["ButtonClick", _event];
    _row ctrlSetTextColor ([[0.78, 0.86, 0.90, 1], [1, 1, 1, 1]] select _selected);

    _curY = _curY + _rowH + _rowGap;
} forEach _widths;

private _close = ["MKK_PTG_RscButton", [_panelX + _pad, _panelY + _panelH - 0.052, _panelW - (_pad * 2), 0.036], [0.08, 0.18, 0.24, 0.95]] call _fncCreateCtrl;
_close ctrlSetText localize "STR_MKK_PTG_CLOSE";
_close ctrlSetEventHandler ["ButtonClick", format ["uiNamespace setVariable ['mkk_ptg_trajectorySettingsVisible', false]; [] call %1", QFUNC(updateTrajectorySettingsMenu)]];

uiNamespace setVariable ["mkk_ptg_trajectorySettingsControls", _allControls];
[] call FUNC(setDashboardControlsBlocked);
