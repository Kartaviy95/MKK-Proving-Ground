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

[] call mkk_ptg_fnc_stopProjectileTrack;

private _camera = "camera" camCreate (getPosASL _projectile);
_camera cameraEffect ["Internal", "Back"];
showCinemaBorder false;
_camera attachTo [_projectile, [0, -3.5, 0.5]];

missionNamespace setVariable ["mkk_ptg_trackingState", createHashMapFromArray [
    ["camera", _camera],
    ["projectile", _projectile],
    ["ammoClass", _ammoClass],
    ["weapon", _weapon],
    ["startTime", diag_tickTime],
    ["startPos", getPosASL _projectile]
]];

missionNamespace setVariable ["mkk_ptg_trackingLastAt", diag_tickTime];

[_projectile] spawn mkk_ptg_fnc_updateProjectileTrack;
