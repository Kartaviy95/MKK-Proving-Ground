#include "..\script_component.hpp"
/*
    Масштабирует все controls в display. Безопасно вызывать повторно после изменения
    размера интерфейса, потому что базовые прямоугольники кэшируются на каждом control.
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
