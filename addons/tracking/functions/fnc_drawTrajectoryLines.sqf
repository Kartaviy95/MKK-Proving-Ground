#include "..\script_component.hpp"
/*
    Рисует сохраненные линии траектории.
*/
if !(missionNamespace getVariable ["mkk_ptg_trajectoryEnabled", false]) exitWith {};

private _lines = missionNamespace getVariable ["mkk_ptg_trajectoryLines", []];
private _now = diag_tickTime;
private _aliveLines = [];
private _color = missionNamespace getVariable ["mkk_ptg_trajectoryColor", [0.10, 0.85, 1.00, 0.95]];
private _width = missionNamespace getVariable ["mkk_ptg_trajectoryLineWidth", 3];

{
    private _points = [];
    private _expiresAt = 0;

    if ((_x # 0) isEqualType "") then {
        _points = _x # 1;
        _expiresAt = _x # 2;
    } else {
        _points = _x # 0;
        _expiresAt = _x # 1;
    };

    if (_expiresAt > _now) then {
        _aliveLines pushBack _x;
        for "_i" from 1 to ((count _points) - 1) do {
            drawLine3D [
                ASLToAGL (_points # (_i - 1)),
                ASLToAGL (_points # _i),
                _color,
                _width
            ];
        };
    };
} forEach _lines;

if ((count _aliveLines) != (count _lines)) then {
    missionNamespace setVariable ["mkk_ptg_trajectoryLines", _aliveLines];
};
