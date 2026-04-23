/*
    Серверный спавн техники.
*/
if !(isServer) exitWith {};

params [
    ["_className", ""],
    ["_requestor", objNull],
    ["_withCrew", false],
    ["_distance", 30]
];

if (_className isEqualTo "") exitWith {};
if (isNull _requestor) exitWith {};

private _catalog = missionNamespace getVariable ["mkk_ptg_catalogCache", []];
if ((_catalog findIf {(_x # 0) isEqualTo _className}) < 0) exitWith {
    [format ["Запрошен неразрешенный classname: %1", _className], "WARN"] call mkk_ptg_fnc_log;
};

private _maxVehicles = missionNamespace getVariable ["mkk_ptg_maxVehicles", 50];
private _spawnedVehicles = missionNamespace getVariable ["mkk_ptg_spawnedVehicles", []];
if ((count _spawnedVehicles) >= _maxVehicles) exitWith {
    ["Лимит техники достигнут.", "WARN"] call mkk_ptg_fnc_log;
};

private _originPos = getPosATL _requestor;
private _dir = getDir _requestor;
private _spawnPos = _originPos getPos [_distance, _dir];

private _vehicle = createVehicle [_className, _spawnPos, [], 0, "NONE"];
_vehicle setDir _dir;
_vehicle setPosATL _spawnPos;

if (_withCrew) then {
    [_vehicle] call mkk_ptg_fnc_spawnCrew;
};

[_vehicle, "vehicle"] call mkk_ptg_fnc_registerSpawnedEntity;

[format ["Создана техника: %1", _className]] call mkk_ptg_fnc_log;
