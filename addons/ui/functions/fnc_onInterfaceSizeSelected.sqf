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

    if !(isNull _bg) then {
        _bg ctrlSetPosition ([[0.64, 0.12, 0.34, 0.42], _hudScale] call EFUNC(common,scaleRect));
        _bg ctrlCommit 0;
    };

    if !(isNull _text) then {
        _text ctrlSetPosition ([[0.65, 0.13, 0.32, 0.42], _hudScale] call EFUNC(common,scaleRect));
        private _titleSize = str ([1.18 * _fontScale, 2] call BIS_fnc_cutDecimals);
        private _rowSize = str ([0.95 * _fontScale, 2] call BIS_fnc_cutDecimals);
        private _noteSize = str ([0.86 * _fontScale, 2] call BIS_fnc_cutDecimals);
        _text ctrlSetStructuredText parseText format [
            "<t align='center' size='%13' font='RobotoCondensedBold' color='#F2F2F2'>%1</t><br/>" +
            "<t size='%14' color='#FFFFFF'>W / S</t><t size='%14' color='#CFCFCF'>    %2</t><br/>" +
            "<t size='%14' color='#FFFFFF'>A / D</t><t size='%14' color='#CFCFCF'>    %3</t><br/>" +
            "<t size='%14' color='#FFFFFF'>Q</t><t size='%14' color='#CFCFCF'>        %4</t><br/>" +
            "<t size='%14' color='#FFFFFF'>Z</t><t size='%14' color='#CFCFCF'>        %5</t><br/>" +
            "<t size='%14' color='#FFFFFF'>Shift</t><t size='%14' color='#CFCFCF'>    %6</t><br/>" +
            "<t size='%14' color='#FFFFFF'>%7</t><t size='%14' color='#CFCFCF'>    %8</t><br/>" +
            "<t size='%14' color='#FFFFFF'>%9</t><t size='%14' color='#CFCFCF'>   %10</t><br/>" +
            "<t size='%14' color='#FFFFFF'>F1</t><t size='%14' color='#CFCFCF'>       %11</t><br/>" +
            "<t align='center' size='%15' color='#DADADA'>%12</t>",
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
[] call FUNC(setDashboardControlsBlocked);
