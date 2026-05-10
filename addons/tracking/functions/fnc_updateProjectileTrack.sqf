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
private _groundFreezeHeight = 150;

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
    private _groundASL = getTerrainHeightASL [_lastPos # 0, _lastPos # 1];
    if (((_lastPos # 2) - _groundASL) <= _groundFreezeHeight) exitWith {};

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
private _stopATL = ASLToATL _lastCameraPos;

_camera camSetPos _stopATL;
_camera camSetTarget _impactATL;
_camera camCommit 0;

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
