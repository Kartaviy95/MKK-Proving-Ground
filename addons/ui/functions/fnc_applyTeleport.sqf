#include "..\script_component.hpp"
/*
    Applies map-click teleport. Ground vehicles are dropped onto the clicked
    land position from a fixed 1.5 meter ATL height.
*/
params [
    ["_mapPos", [], [[]]],
    ["_token", "", [""]]
];

if !(hasInterface) exitWith {[false, ""]};
if !(missionNamespace getVariable ["mkk_ptg_teleportSelecting", false]) exitWith {[false, localize "STR_MKK_PTG_TELEPORT_FAILED"]};

private _activeToken = missionNamespace getVariable ["mkk_ptg_teleportSelectionToken", ""];
if (_token isEqualTo "" || {_token isNotEqualTo _activeToken}) exitWith {[false, localize "STR_MKK_PTG_TELEPORT_FAILED"]};
if ((count _mapPos) < 2) exitWith {[false, localize "STR_MKK_PTG_TELEPORT_FAILED"]};

private _target = vehicle player;
if (isNull _target) exitWith {[false, localize "STR_MKK_PTG_TELEPORT_FAILED"]};

private _targetPos = [_mapPos # 0, _mapPos # 1, 0];

if (surfaceIsWater _targetPos) exitWith {
    _target setVelocity [0, 0, 0];
    _target setPosASL [_mapPos # 0, _mapPos # 1, 3];
    _target setVelocity [0, 0, 0];
    [true, localize "STR_MKK_PTG_TELEPORT_DONE"]
};

private _clearanceRadius = 1.5;
if (_target isNotEqualTo player) then {
    private _bounds = boundingBoxReal _target;
    private _boundsMin = _bounds # 0;
    private _boundsMax = _bounds # 1;
    private _sizeX = abs ((_boundsMax # 0) - (_boundsMin # 0));
    private _sizeY = abs ((_boundsMax # 1) - (_boundsMin # 1));
    _clearanceRadius = (((_sizeX max _sizeY) * 0.5) max 2) min 15;
};

private _mapObstacleTypes = [
    "TREE",
    "SMALL TREE",
    "BUSH",
    "BUILDING",
    "HOUSE",
    "CHURCH",
    "CHAPEL",
    "CROSS",
    "BUNKER",
    "FORTRESS",
    "FOUNTAIN",
    "VIEW-TOWER",
    "LIGHTHOUSE",
    "QUAY",
    "FUELSTATION",
    "HOSPITAL",
    "FENCE",
    "WALL",
    "HIDE",
    "BUSSTOP",
    "TRANSMITTER",
    "STACK",
    "RUIN",
    "TOURISM",
    "WATERTOWER",
    "ROCK",
    "ROCKS",
    "POWERSOLAR",
    "POWERWAVE",
    "POWERWIND",
    "SHIPWRECK"
];
private _mapObstacles = nearestTerrainObjects [_targetPos, _mapObstacleTypes, _clearanceRadius, false, true];
if (_mapObstacles isNotEqualTo []) exitWith {
    [false, localize "STR_MKK_PTG_TELEPORT_BLOCKED_OBJECT"]
};

if (_target isEqualTo player) exitWith {
    _target setPosATL _targetPos;
    [true, localize "STR_MKK_PTG_TELEPORT_DONE"]
};

private _isGroundVehicle = (_target isKindOf "LandVehicle") || {_target isKindOf "StaticWeapon"};
if (_isGroundVehicle isEqualTo false) exitWith {
    _target setVelocity [0, 0, 0];
    _target setPosATL _targetPos;
    _target setVelocity [0, 0, 0];
    [true, localize "STR_MKK_PTG_TELEPORT_DONE"]
};

private _surfaceUp = surfaceNormal _targetPos;
private _dir = getDir _target;
private _desiredForward = [sin _dir, cos _dir, 0];
private _right = _desiredForward vectorCrossProduct _surfaceUp;
if ((vectorMagnitude _right) < 0.001) then {
    _right = [1, 0, 0];
};
private _forward = _surfaceUp vectorCrossProduct _right;
private _forwardMagnitude = vectorMagnitude _forward;
if (_forwardMagnitude < 0.001) then {
    _forward = _desiredForward;
} else {
    _forward = _forward vectorMultiply (1 / _forwardMagnitude);
};

private _lift = 1.5;

_target setVelocity [0, 0, 0];
_target setPosATL [_targetPos # 0, _targetPos # 1, _lift];
_target setVectorDirAndUp [_forward, _surfaceUp];
_target setVelocity [0, 0, 0];

[true, localize "STR_MKK_PTG_TELEPORT_DONE"]
