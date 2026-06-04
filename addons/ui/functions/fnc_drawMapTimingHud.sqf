#include "..\script_component.hpp"
/*
    Updates the local map timing HUD while a timing run is active.
*/
if !(hasInterface) exitWith {};

private _active = missionNamespace getVariable ["mkk_ptg_mapTimingActive", false];
private _hud = uiNamespace getVariable ["mkk_ptg_mapTimingHud", displayNull];

if !(_active) exitWith {
    if !(isNull _hud) then {
        {
            private _ctrl = _hud displayCtrl _x;
            if !(isNull _ctrl) then {
                _ctrl ctrlShow false;
            };
        } forEach [88250, 88251, 88252, 88253];
    };
};

if (visibleMap || {!isNull (findDisplay 88000)} || {!isNull (findDisplay 88900)} || {!isNull (findDisplay 89000)}) exitWith {
    if !(isNull _hud) then {
        {
            private _ctrl = _hud displayCtrl _x;
            if !(isNull _ctrl) then {
                _ctrl ctrlShow false;
            };
        } forEach [88250, 88251, 88252, 88253];
    };
};

if (isNull _hud) then {
    private _layer = "mkk_ptg_mapTimingHudLayer" call BIS_fnc_rscLayer;
    _layer cutRsc ["MKK_PTG_MapTimingHUD", "PLAIN", 0, false];
    _hud = uiNamespace getVariable ["mkk_ptg_mapTimingHud", displayNull];
};
if (isNull _hud) exitWith {};

{
    private _ctrl = _hud displayCtrl _x;
    if !(isNull _ctrl) then {
        _ctrl ctrlShow true;
    };
} forEach [88250, 88251, 88252, 88253];

private _hudScales = [] call EFUNC(common,getHudScale);
private _hudScale = _hudScales # 0;
private _fontScale = _hudScales # 1;

private _marginX = 0.014 * safeZoneW;
private _panelW = (0.165 * safeZoneW * _hudScale) min (safeZoneW - (_marginX * 2));
private _panelH = 0.058 * safeZoneH * _hudScale;
private _panelX = safeZoneX + safeZoneW - _panelW - _marginX;
private _panelY = safeZoneY + (0.150 * safeZoneH);
private _padX = 0.010 * safeZoneW * _hudScale;
private _padY = 0.006 * safeZoneH * _hudScale;
private _accentW = (0.004 * safeZoneW * _hudScale) max pixelW;
private _accentH = (0.004 * safeZoneH * _hudScale) max pixelH;

private _startTime = missionNamespace getVariable ["mkk_ptg_mapTimingStartTime", diag_tickTime];
private _elapsed = floor (diag_tickTime - _startTime);
private _timeText = [_elapsed] call FUNC(formatTimingTime);
private _titleSize = str ([0.58 * _fontScale, 2] call BIS_fnc_cutDecimals);
private _timeSize = str ([1.20 * _fontScale, 2] call BIS_fnc_cutDecimals);

private _panel = _hud displayCtrl 88250;
if !(isNull _panel) then {
    _panel ctrlSetPosition [_panelX, _panelY, _panelW, _panelH];
    _panel ctrlCommit 0;
};

private _accentTop = _hud displayCtrl 88251;
if !(isNull _accentTop) then {
    _accentTop ctrlSetPosition [_panelX, _panelY, _panelW, _accentH];
    _accentTop ctrlCommit 0;
};

private _accentSide = _hud displayCtrl 88252;
if !(isNull _accentSide) then {
    _accentSide ctrlSetPosition [_panelX, _panelY, _accentW, _panelH];
    _accentSide ctrlCommit 0;
};

private _text = _hud displayCtrl 88253;
if !(isNull _text) then {
    _text ctrlSetPosition [_panelX + _padX, _panelY + _padY, _panelW - (_padX * 2), _panelH - (_padY * 2)];
    _text ctrlSetStructuredText parseText format [
        "<t align='left' font='RobotoCondensedBold' size='%3' color='#7FD7FF'>%1</t><br/><t align='left' font='RobotoCondensedBold' size='%4' color='#FFFFFF'>%2</t>",
        localize "STR_MKK_PTG_MAP_TIMING_HUD_TITLE",
        _timeText,
        _titleSize,
        _timeSize
    ];
    _text ctrlCommit 0;
};
