#include "..\script_component.hpp"
/*
    Ведет красный маркер на карте за projectile и оставляет его в последней позиции.
*/
params [
    ["_projectile", objNull],
    ["_ammoClass", ""]
];

if !(hasInterface) exitWith {};
if (isNull _projectile) exitWith {};
if !(missionNamespace getVariable ["mkk_ptg_mapProjectileMarkersEnabled", false]) exitWith {};

private _lastPosASL = getPosASL _projectile;
private _lastPos = ASLToATL _lastPosASL;
private _previousPosASL = [];

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
    if (_fromZ > 0.02 && {_toZ <= 0.02}) then {
        private _deltaZ = _toZ - _fromZ;
        if ((abs _deltaZ) > 0.001) then {
            private _t = (0 - _fromZ) / _deltaZ;
            private _waterPosASL = _fromASL vectorAdd ((_toASL vectorDiff _fromASL) vectorMultiply _t);
            if (surfaceIsWater [_waterPosASL # 0, _waterPosASL # 1]) exitWith {
                _waterPosASL set [2, 0];
                _waterPosASL
            };
        };
    };

    private _fromGroundASL = getTerrainHeightASL [_fromASL # 0, _fromASL # 1];
    private _toGroundASL = getTerrainHeightASL [_toASL # 0, _toASL # 1];
    private _fromAboveGround = _fromZ - _fromGroundASL;
    private _toAboveGround = _toZ - _toGroundASL;
    if (_fromAboveGround > 0.02 && {_toAboveGround <= 0.02}) exitWith {
        [_toASL # 0, _toASL # 1, _toGroundASL]
    };

    []
};

private _markerName = format ["mkk_ptg_projectile_%1_%2", diag_tickTime, floor random 100000];
private _marker = createMarkerLocal [_markerName, _lastPos];
_marker setMarkerTypeLocal "mil_dot";
_marker setMarkerColorLocal "ColorRed";
_marker setMarkerSizeLocal [0.65, 0.65];

if (missionNamespace getVariable ["mkk_ptg_mapProjectileMarkerShowAmmo", false]) then {
    _marker setMarkerTextLocal _ammoClass;
};

private _markers = missionNamespace getVariable ["mkk_ptg_mapProjectileMarkers", []];
_markers pushBack _markerName;
while {(count _markers) > 40} do {
    deleteMarkerLocal (_markers deleteAt 0);
};
missionNamespace setVariable ["mkk_ptg_mapProjectileMarkers", _markers];

private _hitSurface = false;

while {!(isNull _projectile) && {!_hitSurface}} do {
    if !(missionNamespace getVariable ["mkk_ptg_mapProjectileMarkersEnabled", false]) exitWith {
        deleteMarkerLocal _marker;
    };

    private _currentPosASL = getPosASL _projectile;
    private _surfaceHitASL = [_lastPosASL, _currentPosASL] call _fncFindSurfaceHit;
    if (_surfaceHitASL isNotEqualTo []) then {
        _lastPosASL = _surfaceHitASL;
        _hitSurface = true;
    } else {
        _previousPosASL = _lastPosASL;
        _lastPosASL = _currentPosASL;
    };

    _lastPos = ASLToATL _lastPosASL;
    _marker setMarkerPosLocal _lastPos;
    if (!_hitSurface) then {
        uiSleep 0.03;
    };
};

if !(missionNamespace getVariable ["mkk_ptg_mapProjectileMarkersEnabled", false]) exitWith {};

if (!_hitSurface && {_previousPosASL isNotEqualTo []}) then {
    private _impactDir = vectorNormalized (_lastPosASL vectorDiff _previousPosASL);
    if (_impactDir isNotEqualTo [0, 0, 0]) then {
        private _impactProbeDistance = (((_lastPosASL distance _previousPosASL) * 2) max 25) min 250;
        private _surfaceHitASL = [_lastPosASL, _lastPosASL vectorAdd (_impactDir vectorMultiply _impactProbeDistance)] call _fncFindSurfaceHit;
        if (_surfaceHitASL isNotEqualTo []) then {
            _lastPosASL = _surfaceHitASL;
            _lastPos = ASLToATL _lastPosASL;
        };
    };
};

_marker setMarkerPosLocal _lastPos;
if (missionNamespace getVariable ["mkk_ptg_mapProjectileMarkerShowAmmo", false]) then {
    _marker setMarkerTextLocal _ammoClass;
} else {
    _marker setMarkerTextLocal "";
};
