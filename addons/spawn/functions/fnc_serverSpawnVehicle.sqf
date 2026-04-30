#include "..\script_component.hpp"
/*
    Серверный спавн техники.
*/
if !(isServer) exitWith {};

params [
    ["_className", ""],
    ["_requestor", objNull],
    ["_withCrew", false],
    ["_distance", 30],
    ["_directionOffset", 0]
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
