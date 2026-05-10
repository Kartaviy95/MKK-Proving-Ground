#include "..\script_component.hpp"
/*
    Глобальный спавн целей. Может выполняться на клиенте: createVehicle/createUnit синхронизируются в MP.
*/

params [
    ["_mode", "bot"],
    ["_className", ""],
    ["_requestor", objNull],
    ["_distance", 50],
    ["_patrolRadius", 50],
    ["_airRadius", 150],
    ["_airHeight", 100]
];

if (_className isEqualTo "") exitWith {};
if (isNull _requestor) exitWith {};

private _originPos = getPosATL _requestor;
private _dir = getDir _requestor;
private _spawnPos = _originPos getPos [_distance, _dir];
private _faceRequesterDir = _spawnPos getDir _originPos;
private _fncSetPassiveCrew = {
    params [
        ["_vehicle", objNull],
        ["_allowMove", false]
    ];

    private _crew = if (_vehicle isKindOf "Man") then {[_vehicle]} else {crew _vehicle};
    {
        _x setBehaviour "CARELESS";
        _x setCombatMode "BLUE";
        _x disableAI "TARGET";
        _x disableAI "AUTOTARGET";
        _x disableAI "AUTOCOMBAT";
        _x disableAI "SUPPRESSION";
        _x disableAI "COVER";
        _x disableAI "CHECKVISIBLE";
        _x disableAI "WEAPONAIM";
        _x doWatch objNull;
        _x doTarget objNull;

        if (!_allowMove) then {
            _x disableAI "PATH";
            _x disableAI "MOVE";
        };
    } forEach _crew;

    private _group = grpNull;
    {
        if !(isNull _x) exitWith {_group = group _x;};
    } forEach _crew;

    if !(isNull _group) then {
        {
            deleteWaypoint _x;
        } forEach waypoints _group;

        _group setBehaviour "CARELESS";
        _group setCombatMode "BLUE";
        _group setSpeedMode "LIMITED";
        _group enableAttack false;
    };
};

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
    _unit setUnitPos "UP";
    [_unit, false] call _fncSetPassiveCrew;
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
    [_vehicle, true] call _fncSetPassiveCrew;

    _group setBehaviour "CARELESS";
    _group setCombatMode "BLUE";
    _group setSpeedMode "LIMITED";
    _group enableAttack false;

    if (_mode isEqualTo "ground") then {
        {
            private _angle = _faceRequesterDir + _x;
            private _wpPos = _spawnPos getPos [_patrolRadius, _angle];
            private _wp = _group addWaypoint [_wpPos, 0];
            _wp setWaypointType "MOVE";
            _wp setWaypointBehaviour "CARELESS";
            _wp setWaypointCombatMode "BLUE";
            _wp setWaypointSpeed "LIMITED";
            _wp setWaypointCompletionRadius 10;
        } forEach [0, 90, 180, 270];
        private _cyclePos = _spawnPos getPos [_patrolRadius, _faceRequesterDir];
        private _cycle = _group addWaypoint [_cyclePos, 0];
        _cycle setWaypointType "CYCLE";
    } else {
        _vehicle flyInHeight _airHeight;
        {
            private _angle = _x;
            private _wpPos = _originPos getPos [_airRadius, _angle];
            _wpPos set [2, _airHeight];
            private _wp = _group addWaypoint [_wpPos, 0];
            _wp setWaypointType "MOVE";
            _wp setWaypointBehaviour "CARELESS";
            _wp setWaypointCombatMode "BLUE";
            _wp setWaypointSpeed "NORMAL";
        } forEach [_dir, (_dir + 90) % 360, (_dir + 180) % 360, (_dir + 270) % 360];
        private _cyclePos = _originPos getPos [_airRadius, _dir];
        _cyclePos set [2, _airHeight];
        private _cycle = _group addWaypoint [_cyclePos, 0];
        _cycle setWaypointType "CYCLE";
    };
};
