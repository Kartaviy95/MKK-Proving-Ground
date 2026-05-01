#include "..\script_component.hpp"
/*
    Refreshes the centered popup for projectile map marker settings.
*/
disableSerialization;

private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];

private _fncDestroyPopup = {
    private _controls = uiNamespace getVariable ["mkk_ptg_mapProjectileMarkerSettingsControls", []];
    {
        if (!isNull _x) then {
            ctrlDelete _x;
        };
    } forEach _controls;

    uiNamespace setVariable ["mkk_ptg_mapProjectileMarkerSettingsControls", []];
};

call _fncDestroyPopup;

if (isNull _display) exitWith {};
if !(uiNamespace getVariable ["mkk_ptg_mapProjectileMarkerSettingsVisible", false]) exitWith {
    [] call FUNC(setDashboardControlsBlocked);
};

private _allControls = [];
private _panelX = 0.31;
private _panelY = 0.28;
private _panelW = 0.38;
private _panelH = 0.28;
private _pad = 0.018;
private _rowH = 0.042;
private _checkSize = 0.026;
private _checkedTexture = "\A3\ui_f\data\gui\RscCommon\RscCheckBox\CheckBox_checked_ca.paa";
private _uncheckedTexture = "\A3\ui_f\data\gui\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa";

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
_backdrop ctrlSetEventHandler ["ButtonClick", format ["uiNamespace setVariable ['mkk_ptg_mapProjectileMarkerSettingsVisible', false]; [] call %1", QFUNC(updateMapProjectileMarkerSettingsMenu)]];

["MKK_PTG_RscText", [_panelX, _panelY, _panelW, _panelH], [0.010, 0.016, 0.022, 0.985]] call _fncCreateCtrl;
["MKK_PTG_RscText", [_panelX, _panelY, _panelW, 0.004], [0.10, 0.72, 0.92, 0.95]] call _fncCreateCtrl;
["MKK_PTG_RscText", [_panelX, _panelY, 0.004, _panelH], [0.10, 0.72, 0.92, 0.95]] call _fncCreateCtrl;

private _title = ["MKK_PTG_RscText", [_panelX + _pad, _panelY + 0.016, _panelW - (_pad * 2), 0.034]] call _fncCreateCtrl;
_title ctrlSetText localize "STR_MKK_PTG_MAP_MARKER_SETTINGS";
_title ctrlSetTextColor [0.72, 0.88, 1, 1];

private _enabled = missionNamespace getVariable ["mkk_ptg_mapProjectileMarkerShowAmmo", false];
private _texture = [_uncheckedTexture, _checkedTexture] select _enabled;
private _event = format ["[] call %1", QFUNC(toggleMapProjectileMarkerAmmoSetting)];
private _rowColor = [[0.045, 0.055, 0.070, 0.96], [0.060, 0.110, 0.145, 0.96]] select _enabled;

private _rowY = _panelY + 0.080;
private _row = ["MKK_PTG_RscButton", [_panelX + _pad, _rowY, _panelW - (_pad * 2), _rowH], _rowColor] call _fncCreateCtrl;
_row ctrlSetText "";
_row ctrlSetEventHandler ["ButtonClick", _event];

private _check = ["MKK_PTG_RscPictureButton", [_panelX + _pad + 0.010, _rowY + ((_rowH - _checkSize) / 2), _checkSize, _checkSize]] call _fncCreateCtrl;
_check ctrlSetText _texture;
_check ctrlSetEventHandler ["ButtonClick", _event];

private _label = ["MKK_PTG_RscText", [_panelX + _pad + 0.048, _rowY + 0.006, _panelW - (_pad * 2) - 0.062, _rowH - 0.006]] call _fncCreateCtrl;
_label ctrlSetText localize "STR_MKK_PTG_MAP_MARKER_AMMO";
_label ctrlSetTextColor ([[0.78, 0.86, 0.90, 1], [1, 1, 1, 1]] select _enabled);

private _close = ["MKK_PTG_RscButton", [_panelX + _pad, _panelY + _panelH - 0.052, _panelW - (_pad * 2), 0.036], [0.08, 0.18, 0.24, 0.95]] call _fncCreateCtrl;
_close ctrlSetText localize "STR_MKK_PTG_CLOSE";
_close ctrlSetEventHandler ["ButtonClick", format ["uiNamespace setVariable ['mkk_ptg_mapProjectileMarkerSettingsVisible', false]; [] call %1", QFUNC(updateMapProjectileMarkerSettingsMenu)]];

uiNamespace setVariable ["mkk_ptg_mapProjectileMarkerSettingsControls", _allControls];
[] call FUNC(setDashboardControlsBlocked);
