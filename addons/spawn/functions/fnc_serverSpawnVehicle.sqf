#include "..\script_component.hpp"
/*
    Глобальный спавн техники. Может выполняться на клиенте: createVehicle сам синхронизируется в MP.
*/

params [
    ["_className", ""],
    ["_requestor", objNull],
    ["_withCrew", false],
    ["_distance", 30],
    ["_directionOffset", 0],
    ["_ammoBoxClass", ""]
];

if (_className isEqualTo "") exitWith {};
if (isNull _requestor) exitWith {};

private _originPos = getPosATL _requestor;
private _dir = getDir _requestor;
private _spawnPos = _originPos getPos [_distance, _dir];
private _vehicleDir = (_dir + _directionOffset) % 360;

private _vehicle = createVehicle [_className, _spawnPos, [], 0, "NONE"];
_vehicle setDir _vehicleDir;
_vehicle setPosATL _spawnPos;

if (_withCrew) then {
    [_vehicle] call FUNC(spawnCrew);

    _vehicle setVehicleAmmo 0;
    _vehicle setFuel 0;
};

[_vehicle, "vehicle"] call FUNC(registerSpawnedEntity);

if (_ammoBoxClass isNotEqualTo "" && {
    _className isKindOf "StaticWeapon"
    && {isClass (configFile >> "CfgVehicles" >> _ammoBoxClass)}
    && {_ammoBoxClass isKindOf "ReammoBox_F" || {_ammoBoxClass isKindOf "ReammoBox"}}
}) then {
    private _boxPos = _spawnPos getPos [2.5, (_vehicleDir + 90) % 360];
    private _ammoBox = createVehicle [_ammoBoxClass, _boxPos, [], 0, "NONE"];
    _ammoBox setDir _vehicleDir;
    _ammoBox setPosATL _boxPos;

    [_ammoBox, "object"] call FUNC(registerSpawnedEntity);
};
