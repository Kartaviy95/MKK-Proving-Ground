#include "..\script_component.hpp"
/*
    Ведет projectile до конца жизни, затем показывает место падения сверху.
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
private _preImpactStopDistance = 100;
private _impactOverviewHeight = 120;
private _impactOverviewMoveTime = 1.6;

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

private _impactPos = _lastPos;
if ((count _trajectory) > 1) then {
    private _nearPos = _trajectory # ((count _trajectory) - 1);
    private _farPos = _trajectory # ((count _trajectory) - 2);
    private _impactDir = vectorNormalized (_nearPos vectorDiff _farPos);
    if (_impactDir isNotEqualTo [0, 0, 0]) then {
        private _rayEnd = _nearPos vectorAdd (_impactDir vectorMultiply 1000);
        private _hits = lineIntersectsSurfaces [_farPos, _rayEnd, objNull, objNull, true, 1, "GEOM", "NONE"];
        if (_hits isNotEqualTo []) then {
            _impactPos = (_hits # 0) # 0;
        } else {
            private _groundASL = getTerrainHeightASL [_nearPos # 0, _nearPos # 1];
            if ((_impactDir # 2) < -0.001) then {
                private _t = (_groundASL - (_nearPos # 2)) / (_impactDir # 2);
                if (_t > 0) then {
                    _impactPos = _nearPos vectorAdd (_impactDir vectorMultiply _t);
                    _impactPos set [2, getTerrainHeightASL [_impactPos # 0, _impactPos # 1]];
                };
            };
        };
    };
};
if (_impactPos isEqualTo _lastPos) then {
    _impactPos = [
        _lastPos # 0,
        _lastPos # 1,
        getTerrainHeightASL [_lastPos # 0, _lastPos # 1]
    ];
};

detach _camera;
private _impactATL = ASLToATL _impactPos;
private _stopPos = _lastCameraPos;

if ((count _trajectory) > 1) then {
    private _distanceLeft = _preImpactStopDistance;
    private _nextPos = _impactPos;

    for "_idx" from ((count _trajectory) - 1) to 0 step -1 do {
        private _pos = _trajectory # _idx;
        private _segmentLength = _pos distance _nextPos;

        if (_segmentLength >= _distanceLeft) exitWith {
            private _dir = vectorNormalized (_pos vectorDiff _nextPos);
            _stopPos = _nextPos vectorAdd (_dir vectorMultiply _distanceLeft);
        };

        _distanceLeft = _distanceLeft - _segmentLength;
        _stopPos = _pos;
        _nextPos = _pos;
    };
};

private _stopATL = ASLToATL _stopPos;
private _overviewPos = +_impactPos;
_overviewPos set [2, (_impactPos # 2) + _impactOverviewHeight];
private _overviewATL = ASLToATL _overviewPos;

_camera camSetPos _stopATL;
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
