#include "..\script_component.hpp"
/*
    Обновляет отдельное маленькое окно настроек статус-дисплея объектов.
*/
disableSerialization;

private _display = findDisplay 88800;
if (isNull _display) then {
    _display = uiNamespace getVariable ["mkk_ptg_settingsDisplay", displayNull];
};

private _fncDestroyControls = {
    private _controls = uiNamespace getVariable ["mkk_ptg_objectStatusSettingsControls", []];
    {
        if (!isNull _x) then {
            ctrlDelete _x;
        };
    } forEach _controls;

    uiNamespace setVariable ["mkk_ptg_objectStatusSettingsControls", []];
};

call _fncDestroyControls;

if (isNull _display) exitWith {};
if !(uiNamespace getVariable ["mkk_ptg_objectStatusSettingsVisible", false]) exitWith {};

private _fncGetBool = {
    params ["_varName", "_default"];
    missionNamespace getVariable [_varName, _default]
};

private _settings = [
    ["class", "mkk_ptg_objectStatusShowClass", true, localize "STR_MKK_PTG_CLASS", true],
    ["distance", "mkk_ptg_objectStatusShowDistance", true, localize "STR_MKK_PTG_DISTANCE", true],
    ["damage", "mkk_ptg_objectStatusShowDamage", true, localize "STR_MKK_PTG_TOTAL_DAMAGE_SHORT", true],
    ["allowDamage", "mkk_ptg_objectStatusShowAllowDamage", true, localize "STR_MKK_PTG_ALLOW_DAMAGE", true],
    ["hitpoints", "mkk_ptg_objectStatusShowHitpoints", false, localize "STR_MKK_PTG_HITPOINTS", true],
    ["hpHull", "mkk_ptg_objectStatusHpHull", true, localize "STR_MKK_PTG_HP_HULL", missionNamespace getVariable ["mkk_ptg_objectStatusShowHitpoints", false]],
    ["hpEngine", "mkk_ptg_objectStatusHpEngine", true, localize "STR_MKK_PTG_HP_ENGINE", missionNamespace getVariable ["mkk_ptg_objectStatusShowHitpoints", false]],
    ["hpFuel", "mkk_ptg_objectStatusHpFuel", true, localize "STR_MKK_PTG_HP_FUEL", missionNamespace getVariable ["mkk_ptg_objectStatusShowHitpoints", false]],
    ["hpTurret", "mkk_ptg_objectStatusHpTurret", true, localize "STR_MKK_PTG_HP_TURRET", missionNamespace getVariable ["mkk_ptg_objectStatusShowHitpoints", false]],
    ["hpGun", "mkk_ptg_objectStatusHpGun", true, localize "STR_MKK_PTG_HP_GUN", missionNamespace getVariable ["mkk_ptg_objectStatusShowHitpoints", false]]
];

private _allControls = [];
private _panelX = 0.32;
private _panelY = 0.16;
private _panelW = 0.36;
private _panelH = 0.66;
private _pad = 0.018;
private _rowH = 0.038;
private _rowGap = 0.010;
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
_title ctrlSetText localize "STR_MKK_PTG_OBJECT_STATUS_SETTINGS";
_title ctrlSetTextColor [0.72, 0.88, 1, 1];

private _curY = _panelY + 0.065;

private _fncCreateSection = {
    params ["_text"];

    private _ctrl = ["MKK_PTG_RscText", [_panelX + _pad, _curY, _panelW - (_pad * 2), 0.026]] call _fncCreateCtrl;
    _ctrl ctrlSetText _text;
    _ctrl ctrlSetTextColor [0.72, 0.88, 1, 1];
    _curY = _curY + 0.032;
};

private _fncCreateToggle = {
    params ["_setting", "_varName", "_default", "_label", "_active"];

    private _enabled = [_varName, _default] call _fncGetBool;
    private _texture = [_uncheckedTexture, _checkedTexture] select _enabled;
    private _event = format ["['%1'] call %2", _setting, QFUNC(toggleObjectStatusSetting)];
    private _rowColor = if (_active) then {
        [0.105, 0.145, 0.170, 0.98]
    } else {
        [0.045, 0.050, 0.056, 0.78]
    };
    private _textColor = if (_active) then {
        [[0.78, 0.86, 0.90, 1], [1, 1, 1, 1]] select _enabled
    } else {
        [[0.40, 0.46, 0.50, 1], [0.58, 0.66, 0.70, 1]] select _enabled
    };

    private _row = ["MKK_PTG_RscButton", [_panelX + _pad, _curY, _panelW - (_pad * 2), _rowH], _rowColor] call _fncCreateCtrl;
    _row ctrlSetText "";
    _row ctrlSetEventHandler ["ButtonClick", _event];
    _row ctrlEnable _active;

    private _check = ["MKK_PTG_RscPictureButton", [_panelX + _pad + 0.010, _curY + ((_rowH - _checkSize) / 2), _checkSize, _checkSize]] call _fncCreateCtrl;
    _check ctrlSetText _texture;
    _check ctrlSetEventHandler ["ButtonClick", _event];
    _check ctrlEnable _active;

    private _labelCtrl = ["MKK_PTG_RscText", [_panelX + _pad + 0.044, _curY + 0.005, _panelW - (_pad * 2) - 0.058, _rowH - 0.006]] call _fncCreateCtrl;
    _labelCtrl ctrlSetText _label;
    _labelCtrl ctrlSetTextColor _textColor;

    _curY = _curY + _rowH + _rowGap;
};

[localize "STR_MKK_PTG_OBJECT_STATUS_FIELDS"] call _fncCreateSection;
{
    if (_forEachIndex < 5) then {
        _x call _fncCreateToggle;
    };
} forEach _settings;

_curY = _curY + 0.008;
[localize "STR_MKK_PTG_OBJECT_STATUS_HITPOINTS"] call _fncCreateSection;
{
    if (_forEachIndex >= 5) then {
        _x call _fncCreateToggle;
    };
} forEach _settings;

private _close = ["MKK_PTG_RscButtonDanger", [_panelX + _pad, _panelY + _panelH - 0.052, _panelW - (_pad * 2), 0.036], [0.320, 0.075, 0.065, 0.98]] call _fncCreateCtrl;
_close ctrlSetText localize "STR_MKK_PTG_CLOSE";
_close ctrlSetEventHandler ["ButtonClick", format ["[] call %1", QFUNC(closeSettingsDialog)]];

uiNamespace setVariable ["mkk_ptg_objectStatusSettingsControls", _allControls];
