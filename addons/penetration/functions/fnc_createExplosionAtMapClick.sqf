#include "..\script_component.hpp"
/*
    Creates a projectile above the map position and sends it downward.
    Kept local, matching the existing penetration projectile flow.
*/
params [
    ["_ammoClass", ""],
    ["_pos2D", [], [[]]],
    ["_height", 300, [0]],
    ["_requestor", objNull]
];

if (_ammoClass isEqualTo "") exitWith {};
if !(isClass (configFile >> "CfgAmmo" >> _ammoClass)) exitWith {};
if ((count _pos2D) < 2) exitWith {};

private _groundATL = [_pos2D # 0, _pos2D # 1, 0];
private _groundASL = ATLToASL _groundATL;
private _startPosASL = _groundASL vectorAdd [0, 0, _height max 1];

private _speed = getNumber (configFile >> "CfgAmmo" >> _ammoClass >> "typicalSpeed");
if (_speed <= 0) then {_speed = 300;};
_speed = _speed max 120;

private _dir = [0, 0, -1];
private _projectile = createVehicle [_ammoClass, ASLToATL _startPosASL, [], 0, "CAN_COLLIDE"];
_projectile setPosASL _startPosASL;
_projectile setVectorDirAndUp [_dir, [0, 1, 0]];
_projectile setVelocity (_dir vectorMultiply _speed);

private _willOpenTrackingCamera = !isNull _requestor
    && {local _requestor}
    && {missionNamespace getVariable ["mkk_ptg_trackingEnabled", false]}
    && {[_projectile, _ammoClass] call EFUNC(tracking,canTrackProjectile)};

[_projectile, _ammoClass, "", false, true] remoteExec [QEFUNC(tracking,handleProjectileFired), -2];
if (!isNull _requestor) then {
    [_projectile, _ammoClass, "", true, false] remoteExec [QEFUNC(tracking,handleProjectileFired), _requestor];
};

[_projectile, _willOpenTrackingCamera]
