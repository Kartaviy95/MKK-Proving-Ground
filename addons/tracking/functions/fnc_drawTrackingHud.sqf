#include "..\script_component.hpp"
/*
    Рисует простой HUD tracking-системы.
*/
private _state = missionNamespace getVariable ["mkk_ptg_trackingState", createHashMap];
if (_state isEqualType createHashMap && {count _state > 0}) then {
    private _projectile = _state getOrDefault ["projectile", objNull];
    if (isNull _projectile) exitWith {};

    private _ammoClass = _state getOrDefault ["ammoClass", ""];
    private _startTime = _state getOrDefault ["startTime", diag_tickTime];
    private _startPos = _state getOrDefault ["startPos", [0,0,0]];

    private _flightTime = diag_tickTime - _startTime;
    private _distance = _startPos distance (getPosASL _projectile);
    private _mode = missionNamespace getVariable ["mkk_ptg_trackingModeDefault", "TACTICAL"];

    hintSilent format [
        "MKK Projectile Tracking\nБоеприпас: %1\nВремя полета: %2 сек\nДистанция: %3 м\nРежим: %4",
        _ammoClass,
        [_flightTime, 2] call BIS_fnc_cutDecimals,
        round _distance,
        _mode
    ];
};
