#include "..\script_component.hpp"
/*
    Рисует сохраненные линии траектории.
*/
if !(missionNamespace getVariable ["mkk_ptg_trajectoryEnabled", false]) exitWith {};

private _lines = missionNamespace getVariable ["mkk_ptg_trajectoryLines", []];
private _now = diag_tickTime;
private _aliveLines = [];
// Предпочитать uiNamespace (выбор UI), fallback — missionNamespace
private _color = uiNamespace getVariable ["mkk_ptg_trajectoryColor", missionNamespace getVariable ["mkk_ptg_trajectoryColor", []]];
if (_color isEqualTo []) then {
    // если явный цвет отсутствует, попробовать индекс из uiNamespace, затем из missionNamespace
    private _idx = uiNamespace getVariable ["mkk_ptg_trajectoryColorIndex", missionNamespace getVariable ["mkk_ptg_trajectoryColorIndex", 0]];
    private _palette = [
        [0.10, 0.85, 1.00, 1.00],
        [1.00, 0.00, 0.00, 1.00],
        [1.00, 1.00, 0.00, 1.00],
        [0.20, 1.00, 0.25, 1.00],
        [1.00, 0.00, 1.00, 1.00],
        [1.00, 1.00, 1.00, 1.00]
    ];
    private _safeIdx = (_idx max 0) min ((count _palette) - 1);
    _color = _palette # _safeIdx;
};
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
