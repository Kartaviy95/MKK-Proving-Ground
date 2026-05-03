#include "..\script_component.hpp"
/*
    Applies scaled position and font height to a control. The original 0..1
    rectangle is cached on the control, so changing interface size can safely
    re-apply the scale without compounding previous scaling.
*/
params ["_ctrl", ["_baseRect", []], ["_fontHeight", 0.034], ["_scale", -1], ["_fontScale", -1]];
if (isNull _ctrl) exitWith {};

if (_baseRect isEqualTo []) then {
    _baseRect = _ctrl getVariable ["mkk_ptg_baseRect", []];
    if (_baseRect isEqualTo []) then {
        _baseRect = ctrlPosition _ctrl;
        _ctrl setVariable ["mkk_ptg_baseRect", _baseRect];
    };
} else {
    _ctrl setVariable ["mkk_ptg_baseRect", _baseRect];
};

if (_scale < 0 || {_fontScale < 0}) then {
    private _scales = [] call FUNC(getHudScale);
    if (_scale < 0) then {_scale = _scales # 0;};
    if (_fontScale < 0) then {_fontScale = _scales # 1;};
};

_ctrl ctrlSetPosition ([_baseRect, _scale] call FUNC(scaleRect));
_ctrl ctrlCommit 0;

if (_fontHeight > 0) then {
    _ctrl ctrlSetFontHeight (_fontHeight * _fontScale);
};
