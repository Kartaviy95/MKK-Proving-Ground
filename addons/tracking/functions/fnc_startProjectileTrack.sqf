#include "..\script_component.hpp"
/*
    Запускает локальную камеру слежения за projectile.
*/
params [
    ["_projectile", objNull],
    ["_ammoClass", ""],
    ["_weapon", ""]
];

if (isNull _projectile) exitWith {};
if !(hasInterface) exitWith {};

[] call FUNC(stopProjectileTrack);

private _camera = "camera" camCreate (getPosASL _projectile);
_camera cameraEffect ["Internal", "Back"];
showCinemaBorder false;
_camera attachTo [_projectile, [0, -3.5, 0.5]];

private _hudLayer = "mkk_ptg_trackingHudLayer" call BIS_fnc_rscLayer;
_hudLayer cutRsc ["MKK_PTG_TrackingHUD", "PLAIN", 0, false];

missionNamespace setVariable ["mkk_ptg_trackingKeyEH", -1];

private _trackId = missionNamespace getVariable ["mkk_ptg_trackingStateId", 0];
_trackId = _trackId + 1;
missionNamespace setVariable ["mkk_ptg_trackingStateId", _trackId];

missionNamespace setVariable ["mkk_ptg_trackingState", createHashMapFromArray [
    ["id", _trackId],
    ["camera", _camera],
    ["projectile", _projectile],
    ["ammoClass", _ammoClass],
    ["weapon", _weapon],
    ["startTime", diag_tickTime],
    ["startPos", getPosASL _projectile],
    ["lastPos", getPosASL _projectile],
    ["lastVelocity", velocity _projectile]
]];

missionNamespace setVariable ["mkk_ptg_trackingLastAt", diag_tickTime];

[_projectile, _trackId] spawn FUNC(updateProjectileTrack);
