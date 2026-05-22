#include "..\script_component.hpp"
/*
    Ведет projectile до конца жизни, затем мягко отдаляет камеру от подтвержденного места попадания.
*/
params [
    ["_projectile", objNull],
    ["_trackId", -1]
];

private _initialState = missionNamespace getVariable ["mkk_ptg_trackingState", createHashMap];
if !(_initialState isEqualType createHashMap && {(_initialState getOrDefault ["id", -2]) isEqualTo _trackId}) exitWith {};

private _lastPos = _initialState getOrDefault ["lastPos", [0,0,0]];
if !(isNull _projectile) then {
    _lastPos = getPosASL _projectile;
};
private _lastCameraPos = _lastPos;
private _trajectory = [_lastPos];
private _impactHoldTime = 2;
private _impactPullBackDistance = 35;
private _impactOverviewHeight = 16;
private _impactOverviewMoveTime = 1.2;
private _surfaceProbeDistanceMin = 25;
private _surfaceProbeDistanceMax = 250;

private _fncFindSurfaceHit = {
    params ["_fromASL", "_toASL"];

    if ((_fromASL distance _toASL) <= 0.01) exitWith {[]};

    private _hits = lineIntersectsSurfaces [
        _fromASL,
        _toASL,
        player,
        vehicle player,
        true,
        1,
        "GEOM",
        "FIRE"
    ];
    if (_hits isNotEqualTo []) exitWith {(_hits # 0) # 0};

    private _fromZ = _fromASL # 2;
    private _toZ = _toASL # 2;
    private _fromGroundASL = getTerrainHeightASL [_fromASL # 0, _fromASL # 1];
    private _toGroundASL = getTerrainHeightASL [_toASL # 0, _toASL # 1];
    private _fromAboveGround = _fromZ - _fromGroundASL;
    private _toAboveGround = _toZ - _toGroundASL;
    if (_fromAboveGround > 0.02 && {_toAboveGround <= 0.02}) exitWith {
        [_toASL # 0, _toASL # 1, _toGroundASL]
    };

    []
};

while {true} do {
    private _state = missionNamespace getVariable ["mkk_ptg_trackingState", createHashMap];
    if !(_state isEqualType createHashMap && {(_state getOrDefault ["id", -2]) isEqualTo _trackId}) exitWith {};

    private _camera = _state getOrDefault ["camera", objNull];
    if !(isNull _camera) then {
        _lastCameraPos = getPosASL _camera;
    };

    if (isNull _projectile) exitWith {};

    _lastPos = getPosASL _projectile;
    _trajectory pushBack _lastPos;
    _state set ["lastPos", _lastPos];
    _state set ["lastVelocity", velocity _projectile];
    missionNamespace setVariable ["mkk_ptg_trackingState", _state];

    [] call FUNC(drawTrackingHud);

    uiSleep 0.02;
};

private _state = missionNamespace getVariable ["mkk_ptg_trackingState", createHashMap];
if !(_state isEqualType createHashMap && {(_state getOrDefault ["id", -2]) isEqualTo _trackId}) exitWith {};

_lastPos = _state getOrDefault ["lastPos", _lastPos];
private _camera = _state getOrDefault ["camera", objNull];
if (isNull _camera) exitWith {
    [] call FUNC(stopProjectileTrack);
};

private _impactPos = [];
if ((count _trajectory) > 1) then {
    private _nearPos = _trajectory # ((count _trajectory) - 1);
    private _farPos = _trajectory # ((count _trajectory) - 2);
    private _impactDir = vectorNormalized (_nearPos vectorDiff _farPos);
    if (_impactDir isNotEqualTo [0, 0, 0]) then {
        private _surfaceHitASL = [_farPos, _nearPos] call _fncFindSurfaceHit;
        if (_surfaceHitASL isEqualTo []) then {
            private _probeDistance = (((_nearPos distance _farPos) * 2) max _surfaceProbeDistanceMin) min _surfaceProbeDistanceMax;
            _surfaceHitASL = [_nearPos, _nearPos vectorAdd (_impactDir vectorMultiply _probeDistance)] call _fncFindSurfaceHit;
        };

        if (_surfaceHitASL isNotEqualTo []) then {
            _impactPos = _surfaceHitASL;
        };
    };
};

if (_impactPos isEqualTo []) exitWith {
    [] call FUNC(stopProjectileTrack);
};

detach _camera;
private _impactATL = ASLToATL _impactPos;
private _viewDir = vectorNormalized (_lastCameraPos vectorDiff _impactPos);
if (_viewDir isEqualTo [0, 0, 0]) then {
    _viewDir = [0, -1, 0.25];
};
private _overviewPos = _lastCameraPos vectorAdd (_viewDir vectorMultiply _impactPullBackDistance);
private _minOverviewHeight = (getTerrainHeightASL [_overviewPos # 0, _overviewPos # 1]) + 4;
_overviewPos set [2, ((_overviewPos # 2) + _impactOverviewHeight) max _minOverviewHeight];
private _overviewATL = ASLToATL _overviewPos;

_camera camSetPos (ASLToATL _lastCameraPos);
_camera camSetTarget _impactATL;
_camera camCommit 0;

_camera camSetPos _overviewATL;
_camera camSetTarget _impactATL;
_camera camCommit _impactOverviewMoveTime;

private _moveUntil = diag_tickTime + _impactOverviewMoveTime + 0.2;
waitUntil {
    private _currentState = missionNamespace getVariable ["mkk_ptg_trackingState", createHashMap];
    !(_currentState isEqualType createHashMap && {(_currentState getOrDefault ["id", -2]) isEqualTo _trackId})
    || {camCommitted _camera}
    || {diag_tickTime >= _moveUntil}
};

private _holdUntil = diag_tickTime + _impactHoldTime;
while {diag_tickTime < _holdUntil} do {
    private _currentState = missionNamespace getVariable ["mkk_ptg_trackingState", createHashMap];
    if !(_currentState isEqualType createHashMap && {(_currentState getOrDefault ["id", -2]) isEqualTo _trackId}) exitWith {};

    _camera camSetTarget _impactATL;
    _camera camCommit 0;
    [] call FUNC(drawTrackingHud);
    uiSleep 0.02;
};

private _finalState = missionNamespace getVariable ["mkk_ptg_trackingState", createHashMap];
if (_finalState isEqualType createHashMap && {(_finalState getOrDefault ["id", -2]) isEqualTo _trackId}) then {
    [] call FUNC(stopProjectileTrack);
};
