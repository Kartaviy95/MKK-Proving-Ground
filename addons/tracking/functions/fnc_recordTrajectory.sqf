#include "..\script_component.hpp"
/*
    Записывает точки траектории projectile для Draw3D.
*/
params [
    ["_projectile", objNull],
    ["_ammoClass", ""]
];

if (isNull _projectile) exitWith {};
if !(missionNamespace getVariable ["mkk_ptg_trajectoryEnabled", false]) exitWith {};

private _points = [];
private _maxTime = missionNamespace getVariable ["mkk_ptg_trackingMaxTime", 8];
private _startedAt = diag_tickTime;
private _lineId = format ["mkk_ptg_trajectory_%1_%2", diag_tickTime, floor random 100000];
private _expiresAt = diag_tickTime + 20;

private _lines = missionNamespace getVariable ["mkk_ptg_trajectoryLines", []];
_lines pushBack [_lineId, _points, _expiresAt, _ammoClass];
while {(count _lines) > 8} do {
    _lines deleteAt 0;
};
missionNamespace setVariable ["mkk_ptg_trajectoryLines", _lines];

while {
    missionNamespace getVariable ["mkk_ptg_trajectoryEnabled", false]
    && {!(isNull _projectile)
    && {(diag_tickTime - _startedAt) <= _maxTime}}
} do {
    _points pushBack (getPosASL _projectile);
    _expiresAt = diag_tickTime + 20;

    private _currentLines = missionNamespace getVariable ["mkk_ptg_trajectoryLines", []];
    private _idx = _currentLines findIf {
        ((_x # 0) isEqualType "") && {(_x # 0) isEqualTo _lineId}
    };

    if (_idx >= 0) then {
        _currentLines set [_idx, [_lineId, +_points, _expiresAt, _ammoClass]];
        missionNamespace setVariable ["mkk_ptg_trajectoryLines", _currentLines];
    };

    uiSleep 0.03;
};

private _finalLines = missionNamespace getVariable ["mkk_ptg_trajectoryLines", []];
private _idx = _finalLines findIf {
    ((_x # 0) isEqualType "") && {(_x # 0) isEqualTo _lineId}
};

if (_idx >= 0) then {
    if ((count _points) < 2) then {
        _finalLines deleteAt _idx;
    } else {
        _finalLines set [_idx, [_lineId, +_points, diag_tickTime + 20, _ammoClass]];
    };
    missionNamespace setVariable ["mkk_ptg_trajectoryLines", _finalLines];
};
