#include "..\script_component.hpp"
/*
    Создает тестовую цель с экипажем.
*/
params [
    ["_className", ""],
    ["_requestor", objNull],
    ["_withCrew", true]
];

if (hasInterface && {_className isEqualTo ""}) exitWith {
    private _display = uiNamespace getVariable ["mkk_ptg_penetrationDisplay", displayNull];
    if (isNull _display) exitWith {};

    private _ctrlList = _display displayCtrl 88920;
    private _idx = lbCurSel _ctrlList;
    if (_idx < 0) exitWith {
        [localize "STR_MKK_PTG_SELECT_VEHICLE_FIRST"] call EFUNC(main,showTimedHint);
    };

    private _selectedClass = _ctrlList lbData _idx;
    [_selectedClass, player, _withCrew] call FUNC(serverCreateTarget);
};

if (_className isEqualTo "") exitWith {};
if (isNull _requestor) exitWith {};

private _oldTarget = missionNamespace getVariable ["mkk_ptg_penetrationTarget", objNull];
if !(isNull _oldTarget) then {
    deleteVehicleCrew _oldTarget;
    deleteVehicle _oldTarget;
};

private _originPos = getPosATL _requestor;
private _dir = getDir _requestor;
private _spawnDistance = missionNamespace getVariable ["mkk_ptg_penetrationTargetDistance", 120];
private _spawnPos = _originPos getPos [_spawnDistance, _dir];

private _vehicle = createVehicle [_className, _spawnPos, [], 0, "NONE"];
_vehicle setDir (_dir + 180);
_vehicle setPosATL _spawnPos;
_vehicle allowDamage true;

if (_withCrew) then {
    createVehicleCrew _vehicle;
};

[_vehicle, "vehicle"] call EFUNC(spawn,registerSpawnedEntity);

missionNamespace setVariable ["mkk_ptg_penetrationTarget", _vehicle, true];
missionNamespace setVariable ["mkk_ptg_penetrationTargetClass", _className, true];
missionNamespace setVariable ["mkk_ptg_penetrationLastAmmo", "", true];
missionNamespace setVariable ["mkk_ptg_penetrationReport", "", true];
