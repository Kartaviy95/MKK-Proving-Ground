#include "..\script_component.hpp"
/*
    Переключает активную tracking-камеру на первую submunition текущего projectile.
*/
params [
    ["_projectile", objNull],
    ["_trackId", -1]
];

if !(hasInterface) exitWith {};
if (isNull _projectile) exitWith {};

private _state = missionNamespace getVariable ["mkk_ptg_trackingState", createHashMap];
if !(_state isEqualType createHashMap && {(_state getOrDefault ["id", -2]) isEqualTo _trackId}) exitWith {};

private _submunitionEHs = _state getOrDefault ["submunitionEHs", []];
private _alreadyRegistered = false;
{
    _x params [["_registeredProjectile", objNull]];
    if (_registeredProjectile isEqualTo _projectile) exitWith {
        _alreadyRegistered = true;
    };
} forEach _submunitionEHs;
if (_alreadyRegistered) exitWith {};

private _eh = _projectile addEventHandler ["SubmunitionCreated", {
    params ["_projectile", "_submunitionProjectile", "_position", "_velocity"];

    if !(hasInterface) exitWith {};
    if (isNull _submunitionProjectile) exitWith {};

    private _state = missionNamespace getVariable ["mkk_ptg_trackingState", createHashMap];
    if !(_state isEqualType createHashMap && {count _state > 0}) exitWith {};

    private _currentProjectile = _state getOrDefault ["projectile", objNull];
    if (_projectile isNotEqualTo _currentProjectile) exitWith {};

    private _trackId = _state getOrDefault ["id", -2];
    private _camera = _state getOrDefault ["camera", objNull];
    if !(isNull _camera) then {
        detach _camera;
        _camera attachTo [_submunitionProjectile, [0, -3.5, 0.5]];
    };

    private _ammoClass = typeOf _submunitionProjectile;
    private _lastPos = if (_position isEqualType [] && {count _position isEqualTo 3}) then {
        _position
    } else {
        getPosASL _submunitionProjectile
    };

    _state set ["projectile", _submunitionProjectile];
    _state set ["ammoClass", _ammoClass];
    _state set ["lastPos", _lastPos];
    _state set ["lastVelocity", _velocity];
    missionNamespace setVariable ["mkk_ptg_trackingState", _state];

    [_submunitionProjectile, _trackId] call FUNC(registerSubmunitionTracking);
}];

_submunitionEHs pushBack [_projectile, _eh];
_state set ["submunitionEHs", _submunitionEHs];
missionNamespace setVariable ["mkk_ptg_trackingState", _state];
