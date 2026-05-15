#include "..\script_component.hpp"
/*
    Применяет и сохраняет выбранный игроком размер интерфейса.
*/
params ["_combo", "_index"];
if (isNull _combo || {_index < 0}) exitWith {};

private _value = (_combo lbValue _index) / 100;
if !(_value isEqualType 0) exitWith {};
_value = (_value max 0.80) min 1.30;

missionNamespace setVariable ["mkk_ptg_hudSize", _value];
profileNamespace setVariable ["mkk_ptg_hudSize", _value];
saveProfileNamespace;

private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if (isNull _display) exitWith {};

[_display] call EFUNC(common,applyDisplayScale);

/*
    Active RscTitles / ctrlCreate overlays are not children of the main dialog,
    so they must be refreshed separately after the player changes size.
*/
[] call FUNC(drawObjectStatusDisplay);

if !(isNil "ptg_penetration_fnc_updateReport") then {
    [] call ptg_penetration_fnc_updateReport;
};

if (missionNamespace getVariable ["mkk_ptg_hitpointInspectorEnabled", false]) then {
    private _hitpointControls = uiNamespace getVariable ["mkk_ptg_hitpointInspectorHUD", []];
    {
        if (!isNull _x) then {
            ctrlDelete _x;
        };
    } forEach _hitpointControls;

    uiNamespace setVariable ["mkk_ptg_hitpointInspectorHUD", []];
    uiNamespace setVariable ["mkk_ptg_hitpointInspectorTarget", objNull];
    uiNamespace setVariable ["mkk_ptg_hitpointInspectorVisible", false];
    uiNamespace setVariable ["mkk_ptg_hitpointInspectorHUD_workData", []];
};

private _cameraCtrls = missionNamespace getVariable ["mkk_ptg_mapCameraHintCtrls", []];
if ((count _cameraCtrls) >= 2) then {
    private _hudScales = [] call EFUNC(common,getHudScale);
    private _hudScale = _hudScales # 0;
    private _fontScale = _hudScales # 1;
    private _bg = _cameraCtrls # 0;
    private _text = _cameraCtrls # 1;
    private _marginX = 0.014 * safeZoneW;
    private _marginY = 0.014 * safeZoneH;
    private _bgW = (0.37 * safeZoneW * _hudScale) min (safeZoneW - (_marginX * 2));
    private _bgH = (0.38 * safeZoneH * _hudScale) min (safeZoneH - (_marginY * 2));
    private _bgX = safeZoneX + safeZoneW - _bgW - _marginX;
    private _bgY = safeZoneY + _marginY;
    private _padX = 0.010 * safeZoneW * _hudScale;
    private _padY = 0.007 * safeZoneH * _hudScale;
    private _bgRect = [_bgX, _bgY, _bgW, _bgH];
    private _textRect = [_bgX + _padX, _bgY + _padY, _bgW - (_padX * 2), _bgH - (_padY * 2)];

    if !(isNull _bg) then {
        _bg ctrlSetPosition _bgRect;
        _bg ctrlSetBackgroundColor [0, 0, 0, 0.30];
        _bg ctrlCommit 0;
    };

    if !(isNull _text) then {
        _text ctrlSetPosition _textRect;
        private _titleSize = str ([1.18 * _fontScale, 2] call BIS_fnc_cutDecimals);
        private _rowSize = str ([0.95 * _fontScale, 2] call BIS_fnc_cutDecimals);
        private _noteSize = str ([0.86 * _fontScale, 2] call BIS_fnc_cutDecimals);
        _text ctrlSetStructuredText parseText format [
            "<t align='center' size='%16' font='RobotoCondensedBold' color='#F2F2F2'>%1</t><br/>" +
            "<t size='%17' color='#FFFFFF'>W / S</t><t size='%17' color='#CFCFCF'>    %2</t><br/>" +
            "<t size='%17' color='#FFFFFF'>A / D</t><t size='%17' color='#CFCFCF'>    %3</t><br/>" +
            "<t size='%17' color='#FFFFFF'>Q</t><t size='%17' color='#CFCFCF'>        %4</t><br/>" +
            "<t size='%17' color='#FFFFFF'>Z</t><t size='%17' color='#CFCFCF'>        %5</t><br/>" +
            "<t size='%17' color='#FFFFFF'>Shift</t><t size='%17' color='#CFCFCF'>    %6</t><br/>" +
            "<t size='%17' color='#FFFFFF'>%7</t><t size='%17' color='#CFCFCF'>    %8</t><br/>" +
            "<t size='%17' color='#FFFFFF'>%9</t><t size='%17' color='#CFCFCF'>   %10</t><br/>" +
            "<t size='%17' color='#FFFFFF'>%11</t><t size='%17' color='#CFCFCF'>    %12</t><br/>" +
            "<t size='%17' color='#FFFFFF'>N</t><t size='%17' color='#CFCFCF'>        %13</t><br/>" +
            "<t size='%17' color='#FFFFFF'>F1</t><t size='%17' color='#CFCFCF'>       %14</t><br/>" +
            "<t align='center' size='%18' color='#DADADA'>%15</t>",
            localize "STR_MKK_PTG_CAMERA_CONTROLS_TITLE",
            localize "STR_MKK_PTG_CAMERA_CONTROL_FORWARD_BACK",
            localize "STR_MKK_PTG_CAMERA_CONTROL_LEFT_RIGHT",
            localize "STR_MKK_PTG_CAMERA_CONTROL_UP",
            localize "STR_MKK_PTG_CAMERA_CONTROL_DOWN",
            localize "STR_MKK_PTG_CAMERA_CONTROL_SPEED",
            localize "STR_MKK_PTG_CAMERA_CONTROL_MOUSE",
            localize "STR_MKK_PTG_CAMERA_CONTROL_LOOK",
            localize "STR_MKK_PTG_CAMERA_CONTROL_WHEEL",
            localize "STR_MKK_PTG_CAMERA_CONTROL_SPEED_CHANGE",
            localize "STR_MKK_PTG_CAMERA_CONTROL_LMB",
            localize "STR_MKK_PTG_CAMERA_CONTROL_RELOCATE",
            localize "STR_MKK_PTG_CAMERA_CONTROL_NIGHT_VISION",
            localize "STR_MKK_PTG_CAMERA_CONTROL_TOGGLE_HINT",
            localize "STR_MKK_PTG_CAMERA_CONTROL_CLOSE_NOTE",
            _titleSize,
            _rowSize,
            _noteSize
        ];
        _text ctrlCommit 0;
    };
};

/* Dynamic popup controls are recreated from their original normalized coords. */
[] call FUNC(updateObjectStatusSettingsMenu);
[] call FUNC(updateTrajectorySettingsMenu);
[] call FUNC(updateMapProjectileMarkerSettingsMenu);
[] call FUNC(updateDashboardStatusLine);
[] call FUNC(setDashboardControlsBlocked);
