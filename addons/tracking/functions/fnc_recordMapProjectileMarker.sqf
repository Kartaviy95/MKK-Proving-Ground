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

private _markerName = format ["mkk_ptg_projectile_%1_%2", diag_tickTime, floor random 100000];
private _marker = createMarkerLocal [_markerName, getPosATL _projectile];
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

private _lastPos = getPosATL _projectile;
private _maxTime = missionNamespace getVariable ["mkk_ptg_trackingMaxTime", 8];
private _startedAt = diag_tickTime;

while {!(isNull _projectile) && {(diag_tickTime - _startedAt) <= _maxTime}} do {
    if !(missionNamespace getVariable ["mkk_ptg_mapProjectileMarkersEnabled", false]) exitWith {
        deleteMarkerLocal _marker;
    };

    _lastPos = getPosATL _projectile;
    _marker setMarkerPosLocal _lastPos;
    uiSleep 0.03;
};

if !(missionNamespace getVariable ["mkk_ptg_mapProjectileMarkersEnabled", false]) exitWith {};

_marker setMarkerPosLocal _lastPos;
if (missionNamespace getVariable ["mkk_ptg_mapProjectileMarkerShowAmmo", false]) then {
    _marker setMarkerTextLocal _ammoClass;
} else {
    _marker setMarkerTextLocal "";
};
