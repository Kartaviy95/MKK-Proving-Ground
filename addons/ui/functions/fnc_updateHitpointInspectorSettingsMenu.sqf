#include "..\script_component.hpp"
/*
    Обновляет отдельное маленькое окно настроек инспектора hitpoints.
*/
disableSerialization;

private _display = findDisplay 88800;
if (isNull _display) then {
    _display = uiNamespace getVariable ["mkk_ptg_settingsDisplay", displayNull];
};

private _fncDestroyControls = {
    private _controls = uiNamespace getVariable ["mkk_ptg_hitpointInspectorSettingsControls", []];
    {
        if (!isNull _x) then {
            ctrlDelete _x;
        };
    } forEach _controls;

    uiNamespace setVariable ["mkk_ptg_hitpointInspectorSettingsControls", []];
};

call _fncDestroyControls;

if (isNull _display) exitWith {};
if !(uiNamespace getVariable ["mkk_ptg_hitpointInspectorSettingsVisible", false]) exitWith {};

private _fncGetBool = {
    params ["_varName", "_default"];
    missionNamespace getVariable [_varName, _default]
};

private _settings = [
    ["hpEngine", "mkk_ptg_hitpointInspectorHpEngine", true, localize "STR_MKK_PTG_HP_ENGINE"],
    ["hpHull", "mkk_ptg_hitpointInspectorHpHull", true, localize "STR_MKK_PTG_HP_HULL"],
    ["hpTurret", "mkk_ptg_hitpointInspectorHpTurret", true, localize "STR_MKK_PTG_HP_TURRET"],
    ["hpGun", "mkk_ptg_hitpointInspectorHpGun", true, localize "STR_MKK_PTG_HP_GUN"],
    ["hpWheels", "mkk_ptg_hitpointInspectorHpWheels", false, localize "STR_MKK_PTG_HP_WHEELS"],
    ["hpTracks", "mkk_ptg_hitpointInspectorHpTracks", false, localize "STR_MKK_PTG_HP_TRACKS"],
    ["hpFuel", "mkk_ptg_hitpointInspectorHpFuel", false, localize "STR_MKK_PTG_HP_FUEL"]
];

private _allControls = [];
private _panelX = 0.34;
private _panelY = 0.20;
private _panelW = 0.32;
private _panelH = 0.60;
private _pad = 0.018;
private _rowH = 0.038;
private _rowGap = 0.008;
private _checkSize = 0.024;
private _checkedTexture = "\A3\ui_f\data\gui\RscCommon\RscCheckBox\CheckBox_checked_ca.paa";
private _uncheckedTexture = "\A3\ui_f\data\gui\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa";

private _fncCreateCtrl = {
    params ["_className", "_pos", ["_bgColor", [0, 0, 0, 0]]];

    private _ctrl = _display ctrlCreate [_className, -1];
    [_ctrl, _pos] call EFUNC(common,applyHudControlScale);
    _ctrl ctrlSetBackgroundColor _bgColor;
    _ctrl ctrlCommit 0;
    _allControls pushBack _ctrl;

    _ctrl
};

["MKK_PTG_RscText", [_panelX, _panelY, _panelW, _panelH], [0.010, 0.016, 0.022, 0.985]] call _fncCreateCtrl;
["MKK_PTG_RscText", [_panelX, _panelY, _panelW, 0.004], [0.10, 0.72, 0.92, 0.95]] call _fncCreateCtrl;
["MKK_PTG_RscText", [_panelX, _panelY, 0.004, _panelH], [0.10, 0.72, 0.92, 0.95]] call _fncCreateCtrl;

private _title = ["MKK_PTG_RscText", [_panelX + _pad, _panelY + 0.016, _panelW - (_pad * 2), 0.034]] call _fncCreateCtrl;
_title ctrlSetText localize "STR_MKK_PTG_HITPOINT_INSPECTOR_SETTINGS";
_title ctrlSetTextColor [0.72, 0.88, 1, 1];

private _curY = _panelY + 0.065;

private _section = ["MKK_PTG_RscText", [_panelX + _pad, _curY, _panelW - (_pad * 2), 0.026]] call _fncCreateCtrl;
_section ctrlSetText localize "STR_MKK_PTG_HITPOINT_INSPECTOR_FIELDS";
_section ctrlSetTextColor [0.72, 0.88, 1, 1];
_curY = _curY + 0.032;

private _fncCreateToggle = {
    params ["_setting", "_varName", "_default", "_label"];

    private _enabled = [_varName, _default] call _fncGetBool;
    private _texture = [_uncheckedTexture, _checkedTexture] select _enabled;
    private _event = format ["['%1'] call %2", _setting, QFUNC(toggleHitpointInspectorSetting)];
    private _rowColor = [0.105, 0.145, 0.170, 0.98];
    private _textColor = [[0.78, 0.86, 0.90, 1], [1, 1, 1, 1]] select _enabled;

    private _row = ["MKK_PTG_RscButton", [_panelX + _pad, _curY, _panelW - (_pad * 2), _rowH], _rowColor] call _fncCreateCtrl;
    _row ctrlSetText "";
    _row ctrlSetEventHandler ["ButtonClick", _event];

    private _check = ["MKK_PTG_RscPictureButton", [_panelX + _pad + 0.010, _curY + ((_rowH - _checkSize) / 2), _checkSize, _checkSize]] call _fncCreateCtrl;
    _check ctrlSetText _texture;
    _check ctrlSetEventHandler ["ButtonClick", _event];

    private _labelCtrl = ["MKK_PTG_RscText", [_panelX + _pad + 0.044, _curY + 0.005, _panelW - (_pad * 2) - 0.058, _rowH - 0.006]] call _fncCreateCtrl;
    _labelCtrl ctrlSetText _label;
    _labelCtrl ctrlSetTextColor _textColor;

    _curY = _curY + _rowH + _rowGap;
};

{
    _x call _fncCreateToggle;
} forEach _settings;

private _close = ["MKK_PTG_RscButtonDanger", [_panelX + _pad, _panelY + _panelH - 0.052, _panelW - (_pad * 2), 0.036], [0.320, 0.075, 0.065, 0.98]] call _fncCreateCtrl;
_close ctrlSetText localize "STR_MKK_PTG_CLOSE";
_close ctrlSetEventHandler ["ButtonClick", format ["[] call %1", QFUNC(closeSettingsDialog)]];

uiNamespace setVariable ["mkk_ptg_hitpointInspectorSettingsControls", _allControls];

