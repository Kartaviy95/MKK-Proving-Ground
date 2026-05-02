#include "..\script_component.hpp"
/*
    Рисует простой HUD tracking-системы.
*/
private _state = missionNamespace getVariable ["mkk_ptg_trackingState", createHashMap];
if (_state isEqualType createHashMap && {count _state > 0}) then {
    private _projectile = _state getOrDefault ["projectile", objNull];
    if (isNull _projectile) exitWith {};

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
    private _distance = _startPos distance (getPosASL _projectile);
    private _velocity = velocity _projectile;
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

    private _text = format [
        localize "STR_MKK_PTG_TRACKING_HUD",
        _ammoClass,
        [_flightTime, 2] call BIS_fnc_cutDecimals,
        round _distance,
        _mode,
        _speed
    ];

    (_hud displayCtrl 88302) ctrlSetStructuredText parseText _text;
};
