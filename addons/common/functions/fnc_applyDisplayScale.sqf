#include "..\script_component.hpp"
/*
    Scales all controls in a display. Safe to call repeatedly after the player
    changes interface size because base rectangles are cached per control.
*/
params ["_display"];
if (isNull _display) exitWith {};

private _scales = [] call FUNC(getHudScale);
private _scale = _scales # 0;
private _fontScale = _scales # 1;

{
    private _ctrl = _x;
    if !(isNull _ctrl) then {
        [_ctrl, [], 0.034, _scale, _fontScale] call FUNC(applyHudControlScale);
    };
} forEach (allControls _display);
