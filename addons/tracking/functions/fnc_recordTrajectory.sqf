#include "..\script_component.hpp"
/*
    Записывает точки траектории projectile для Draw3D.
*/
params [
    ["_projectile", objNull],
    ["_ammoClass", ""]
];

if (isNull _projectile) exitWith {};

private _points = [];
private _maxTime = missionNamespace getVariable ["mkk_ptg_trackingMaxTime", 8];
private _startedAt = diag_tickTime;

while {!(isNull _projectile) && {(diag_tickTime - _startedAt) <= _maxTime}} do {
    _points pushBack (getPosASL _projectile);
    uiSleep 0.03;
};

if ((count _points) < 2) exitWith {};

private _lines = missionNamespace getVariable ["mkk_ptg_trajectoryLines", []];
_lines pushBack [_points, diag_tickTime + 20, _ammoClass];
if ((count _lines) > 8) then {
    _lines deleteAt 0;
};
missionNamespace setVariable ["mkk_ptg_trajectoryLines", _lines];
