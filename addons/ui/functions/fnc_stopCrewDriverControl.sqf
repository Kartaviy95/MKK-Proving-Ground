#include "..\script_component.hpp"
/*
    Останавливает управление водителем из слота стрелка и очищает key handlers.
*/
if !(hasInterface) exitWith {};

missionNamespace setVariable ["mkk_ptg_crewDriverControlRunning", false];

private _state = missionNamespace getVariable ["mkk_ptg_crewDriverControlState", createHashMap];
private _vehicle = _state getOrDefault ["vehicle", objNull];
private _driver = _state getOrDefault ["driver", objNull];
if !(isNull _vehicle) then {
    {
        _vehicle lockTurret [_x, false];
    } forEach allTurrets _vehicle;
};
if !(isNull _driver) then {
    _driver forceSpeed -1;
};

private _display = findDisplay 46;
private _ehs = missionNamespace getVariable ["mkk_ptg_crewDriverControlEHs", []];
if !(isNull _display) then {
    if ((count _ehs) > 0) then {_display displayRemoveEventHandler ["KeyDown", _ehs # 0];};
    if ((count _ehs) > 1) then {_display displayRemoveEventHandler ["KeyUp", _ehs # 1];};
};

missionNamespace setVariable ["mkk_ptg_crewDriverControlEHs", []];
missionNamespace setVariable ["mkk_ptg_crewDriverControlState", createHashMap];
