#include "..\script_component.hpp"
/*
    Рисует сохраненные линии траектории.
*/
if !(missionNamespace getVariable ["mkk_ptg_trajectoryEnabled", false]) exitWith {};

private _lines = missionNamespace getVariable ["mkk_ptg_trajectoryLines", []];
private _now = diag_tickTime;
private _aliveLines = [];

{
    _x params ["_points", "_expiresAt"];
    if (_expiresAt > _now) then {
        _aliveLines pushBack _x;
        for "_i" from 1 to ((count _points) - 1) do {
            drawLine3D [
                ASLToAGL (_points # (_i - 1)),
                ASLToAGL (_points # _i),
                [0.1, 0.8, 1, 0.9]
            ];
        };
    };
} forEach _lines;

if ((count _aliveLines) != (count _lines)) then {
    missionNamespace setVariable ["mkk_ptg_trajectoryLines", _aliveLines];
};
