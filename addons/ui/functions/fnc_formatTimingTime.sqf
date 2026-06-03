#include "..\script_component.hpp"
/*
    Formats a timing value in seconds as HH:MM:SS.
*/
params [["_seconds", 0, [0]]];

_seconds = round (_seconds max 0);

private _h = floor (_seconds / 3600);
private _m = floor ((_seconds % 3600) / 60);
private _s = _seconds % 60;

private _pad = {
    params [["_n", 0, [0]]];
    if (_n < 10) then {format ["0%1", _n]} else {str _n};
};

format ["%1:%2:%3", [_h] call _pad, [_m] call _pad, [_s] call _pad]
