#include "..\script_component.hpp"
/*
    Ведет projectile до столкновения, затем показывает место падения сверху.
*/
params [
    ["_projectile", objNull],
    ["_trackId", -1]
];

if (isNull _projectile) exitWith {};

private _lastPos = getPosASL _projectile;
private _lastCameraPos = _lastPos;
private _trajectory = [_lastPos];
private _impactHoldTime = 3;
private _impactLiftHeight = 12;
private _impactLiftTime = 1.5;
private _preImpactStopDistance = 50;

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

private _stopPos = _lastPos;
private _remainingDistance = _preImpactStopDistance max 0;
if (_remainingDistance > 0 && {count _trajectory > 1}) then {
    private _nearerPos = _lastPos;

    for "_i" from ((count _trajectory) - 2) to 0 step -1 do {
        private _fartherPos = _trajectory # _i;
        private _segmentLength = _fartherPos distance _nearerPos;

        if (_segmentLength >= _remainingDistance) exitWith {
            private _ratio = _remainingDistance / _segmentLength;
            _stopPos = [
                (_nearerPos # 0) + (((_fartherPos # 0) - (_nearerPos # 0)) * _ratio),
                (_nearerPos # 1) + (((_fartherPos # 1) - (_nearerPos # 1)) * _ratio),
                (_nearerPos # 2) + (((_fartherPos # 2) - (_nearerPos # 2)) * _ratio)
            ];
        };

        _remainingDistance = _remainingDistance - _segmentLength;
        _nearerPos = _fartherPos;
        _stopPos = _fartherPos;
    };
};

detach _camera;
private _impactATL = ASLToATL _lastPos;
private _stopATL = ASLToATL _stopPos;
private _overviewATL = ASLToATL [
    _stopPos # 0,
    _stopPos # 1,
    (_stopPos # 2) + _impactLiftHeight
];

_camera camSetPos _stopATL;
_camera camSetTarget _impactATL;
_camera camCommit 0;

_camera camSetPos _overviewATL;
_camera camSetTarget _impactATL;
_camera camCommit _impactLiftTime;

private _liftStartedAt = diag_tickTime;
while {!(camCommitted _camera) && {(diag_tickTime - _liftStartedAt) <= (_impactLiftTime + 0.2)}} do {
    [] call FUNC(drawTrackingHud);
    uiSleep 0.02;
};

private _holdUntil = diag_tickTime + _impactHoldTime;
while {diag_tickTime < _holdUntil} do {
    private _currentState = missionNamespace getVariable ["mkk_ptg_trackingState", createHashMap];
    if !(_currentState isEqualType createHashMap && {(_currentState getOrDefault ["id", -2]) isEqualTo _trackId}) exitWith {};

    _camera camSetTarget _impactATL;
    [] call FUNC(drawTrackingHud);
    uiSleep 0.02;
};

private _finalState = missionNamespace getVariable ["mkk_ptg_trackingState", createHashMap];
if (_finalState isEqualType createHashMap && {(_finalState getOrDefault ["id", -2]) isEqualTo _trackId}) then {
    [] call FUNC(stopProjectileTrack);
};
