#include "..\script_component.hpp"
/*
    Рисует простой HUD tracking-системы.
*/
private _state = missionNamespace getVariable ["mkk_ptg_trackingState", createHashMap];
if (_state isEqualType createHashMap && {count _state > 0}) then {
    private _projectile = _state getOrDefault ["projectile", objNull];
    private _currentPos = _state getOrDefault ["lastPos", [0,0,0]];
    private _velocity = _state getOrDefault ["lastVelocity", [0,0,0]];
    if !(isNull _projectile) then {
        _currentPos = getPosASL _projectile;
        _velocity = velocity _projectile;
    };

    private _ammoClass = _state getOrDefault ["ammoClass", ""];
    if (_ammoClass isEqualTo "") then {
        _ammoClass = typeOf _projectile;
    };
    if (_ammoClass isEqualTo "") then {
        _ammoClass = localize "STR_MKK_PTG_UNKNOWN";
    };

    private _startTime = _state getOrDefault ["startTime", diag_tickTime];
    private _startPos = _state getOrDefault ["startPos", [0,0,0]];

    private _flightTime = diag_tickTime - _startTime;
    private _distance = _startPos distance _currentPos;
    private _speed = round (sqrt (
        ((_velocity # 0) * (_velocity # 0)) +
        ((_velocity # 1) * (_velocity # 1)) +
        ((_velocity # 2) * (_velocity # 2))
    ));
    private _mode = missionNamespace getVariable ["mkk_ptg_trackingModeDefault", "TACTICAL"];

    private _hud = uiNamespace getVariable ["mkk_ptg_trackingHud", displayNull];
    if (isNull _hud) then {
        private _hudLayer = "mkk_ptg_trackingHudLayer" call BIS_fnc_rscLayer;
        _hudLayer cutRsc ["MKK_PTG_TrackingHUD", "PLAIN", 0, false];
        _hud = uiNamespace getVariable ["mkk_ptg_trackingHud", displayNull];
    };
    if (isNull _hud) exitWith {};

    private _hudScales = [] call EFUNC(common,getHudScale);
    private _hudScale = _hudScales # 0;
    private _fontScale = _hudScales # 1;

    private _panelRect = [[0.035, 0.055, 0.36, 0.28], _hudScale] call EFUNC(common,scaleRect);
    _panelRect params ["_panelX", "_panelY", "_panelW", "_panelH"];
    private _padX = 0.015 * safeZoneW * _hudScale;
    private _padY = 0.015 * safeZoneH * _hudScale;
    private _accentH = (0.004 * safeZoneH * _hudScale) max pixelH;

    private _panel = _hud displayCtrl 88300;
    if !(isNull _panel) then {
        _panel ctrlSetPosition _panelRect;
        _panel ctrlCommit 0;
    };

    private _accent = _hud displayCtrl 88301;
    if !(isNull _accent) then {
        _accent ctrlSetPosition [_panelX, _panelY, _panelW, _accentH];
        _accent ctrlCommit 0;
    };

    private _textCtrl = _hud displayCtrl 88302;
    if !(isNull _textCtrl) then {
        _textCtrl ctrlSetPosition [_panelX + _padX, _panelY + _padY, _panelW - (_padX * 2), _panelH - (_padY * 2)];
        _textCtrl ctrlCommit 0;
    };

    private _text = format [
        localize "STR_MKK_PTG_TRACKING_HUD",
        _ammoClass,
        [_flightTime, 2] call BIS_fnc_cutDecimals,
        round _distance,
        _mode,
        _speed
    ];

    if !(isNull _textCtrl) then {
        _textCtrl ctrlSetStructuredText parseText format ["<t size='%1'>%2</t>", str ([1.75 * _fontScale, 2] call BIS_fnc_cutDecimals), _text];
    };
};
