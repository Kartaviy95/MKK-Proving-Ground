#include "..\script_component.hpp"
/*
    Серверный спавн целей.
*/
if !(isServer) exitWith {};

params [
    ["_mode", "bot"],
    ["_className", ""],
    ["_requestor", objNull],
    ["_distance", 5],
    ["_sector", 50],
    ["_airRadius", 150],
    ["_airHeight", 100]
];

if (_className isEqualTo "") exitWith {};
if (isNull _requestor) exitWith {};

private _originPos = getPosATL _requestor;
private _dir = getDir _requestor;
private _spawnPos = _originPos getPos [_distance, _dir];
private _faceRequesterDir = _spawnPos getDir _originPos;

if (_mode isEqualTo "bot") exitWith {
    private _side = switch (_className) do {
        case "B_Survivor_F": {west};
        case "O_Survivor_F": {east};
        case "I_Survivor_F": {independent};
        default {east};
    };
    private _group = createGroup [_side, true];
    private _unit = _group createUnit [_className, _spawnPos, [], 0, "NONE"];
    _unit setDir _faceRequesterDir;
    _unit setPosATL _spawnPos;
    removeAllWeapons _unit;
    removeAllItems _unit;
    removeAllAssignedItems _unit;
    _unit disableAI "PATH";
    _unit disableAI "MOVE";
    _unit setUnitPos "UP";
    _unit setBehaviour "CARELESS";
    (group _unit) setCombatMode "BLUE";
    [_unit] call FUNC(registerTargetEntity);
};

if (_mode isEqualTo "air") then {
    _spawnPos set [2, _airHeight];
};

private _special = ["NONE", "FLY"] select (_mode isEqualTo "air");
private _vehicle = createVehicle [_className, _spawnPos, [], 0, _special];
_vehicle setDir _faceRequesterDir;
_vehicle setPosATL _spawnPos;
[_vehicle] call FUNC(spawnCrew);
_vehicle setVehicleAmmo 0;

if (_mode isEqualTo "air") then {
    private _airSpeedKmh = getNumber (configFile >> "CfgVehicles" >> _className >> "maxSpeed");
    private _airSpeedMs = (((_airSpeedKmh max 120) min 450) / 3.6);
    _vehicle engineOn true;
    _vehicle flyInHeight _airHeight;
    _vehicle setVelocity ((vectorDir _vehicle) vectorMultiply _airSpeedMs);
};

[_vehicle] call FUNC(registerTargetEntity);

private _group = grpNull;
{
    if !(isNull _x) exitWith {_group = group _x;};
} forEach crew _vehicle;

if !(isNull _group) then {
    _group setBehaviour "AWARE";
    _group setCombatMode "RED";
    _group setSpeedMode "LIMITED";

    if (_mode isEqualTo "ground") then {
        private _wp = _group addWaypoint [_spawnPos, _sector];
        _wp setWaypointType "SAD";
        _wp setWaypointBehaviour "AWARE";
        _wp setWaypointCombatMode "RED";
        _wp setWaypointCompletionRadius (_sector max 10);
        private _cycle = _group addWaypoint [_spawnPos, 0];
        _cycle setWaypointType "CYCLE";
    } else {
        _vehicle flyInHeight _airHeight;
        {
            private _angle = _x;
            private _wpPos = _originPos getPos [_airRadius, _angle];
            _wpPos set [2, _airHeight];
            private _wp = _group addWaypoint [_wpPos, 0];
            _wp setWaypointType "MOVE";
            _wp setWaypointBehaviour "AWARE";
            _wp setWaypointCombatMode "RED";
            _wp setWaypointSpeed "NORMAL";
        } forEach [_dir, (_dir + 90) % 360, (_dir + 180) % 360, (_dir + 270) % 360];
        private _cyclePos = _originPos getPos [_airRadius, _dir];
        _cyclePos set [2, _airHeight];
        private _cycle = _group addWaypoint [_cyclePos, 0];
        _cycle setWaypointType "CYCLE";
    };
};
