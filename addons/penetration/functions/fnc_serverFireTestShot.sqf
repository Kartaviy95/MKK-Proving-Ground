#include "..\script_component.hpp"
/*
    Создает тестовый projectile, направленный в центр цели.
*/
if !(isServer) exitWith {};

params [
    ["_target", objNull],
    ["_ammoClass", ""],
    ["_requestor", objNull],
    ["_impactPosASL", []]
];

if (isNull _target) exitWith {};
if (_ammoClass isEqualTo "") exitWith {};
if !(isClass (configFile >> "CfgAmmo" >> _ammoClass)) exitWith {};

private _targetPos = if (_impactPosASL isEqualType [] && {count _impactPosASL isEqualTo 3}) then {
    _impactPosASL
} else {
    getPosASL _target vectorAdd [0, 0, 1.2]
};
private _startDistance = missionNamespace getVariable ["mkk_ptg_penetrationShotDistance", 70];
private _sourcePos = if (isNull _requestor) then {
    getPosASL _target vectorAdd [0, -_startDistance, 1.5]
} else {
    eyePos _requestor
};
private _shotDir = vectorNormalized (_targetPos vectorDiff _sourcePos);
private _startPos = _targetPos vectorAdd (_shotDir vectorMultiply -_startDistance);

private _vector = _targetPos vectorDiff _startPos;
private _dir = vectorNormalized _vector;
private _speed = getNumber (configFile >> "CfgAmmo" >> _ammoClass >> "typicalSpeed");
if (_speed <= 0) then {_speed = 900;};

private _projectile = createVehicle [_ammoClass, ASLToATL _startPos, [], 0, "CAN_COLLIDE"];
_projectile setPosASL _startPos;
_projectile setVectorDirAndUp [_dir, [0,0,1]];
_projectile setVelocity (_dir vectorMultiply _speed);

[_projectile, _ammoClass, "", false, true] remoteExec [QEFUNC(tracking,handleProjectileFired), 0];
if (!isNull _requestor) then {
    [_projectile, _ammoClass, "", true, false] remoteExec [QEFUNC(tracking,handleProjectileFired), _requestor];
};
missionNamespace setVariable ["mkk_ptg_penetrationLastAmmo", _ammoClass, true];
