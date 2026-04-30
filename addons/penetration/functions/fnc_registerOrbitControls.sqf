#include "..\script_component.hpp"
/*
    Регистрирует ручное управление orbit-камерой.
*/
if !(hasInterface) exitWith {};

private _display = findDisplay 46;
if (isNull _display) exitWith {};
if (missionNamespace getVariable ["mkk_ptg_penetrationOrbitControlsAdded", false]) exitWith {};

private _mouseEH = _display displayAddEventHandler ["MouseMoving", {
    params ["_display", "_xDelta", "_yDelta"];
    if !(missionNamespace getVariable ["mkk_ptg_penetrationCameraRunning", false]) exitWith {};

    private _state = missionNamespace getVariable ["mkk_ptg_penetrationCameraState", createHashMap];
    private _angle = (_state getOrDefault ["angle", 180]) - (_xDelta * 0.35);
    private _height = ((_state getOrDefault ["height", 3]) + (_yDelta * 0.08)) max 0.5 min 12;

    _state set ["angle", _angle % 360];
    _state set ["height", _height];
}];

private _wheelEH = _display displayAddEventHandler ["MouseZChanged", {
    params ["_display", "_scroll"];
    if !(missionNamespace getVariable ["mkk_ptg_penetrationCameraRunning", false]) exitWith {};

    private _state = missionNamespace getVariable ["mkk_ptg_penetrationCameraState", createHashMap];
    private _distance = ((_state getOrDefault ["distance", 12]) - (_scroll * 0.9)) max 3 min 45;
    _state set ["distance", _distance];
}];

private _keyEH = _display displayAddEventHandler ["KeyDown", {
    params ["_display", "_key"];
    if !(missionNamespace getVariable ["mkk_ptg_penetrationCameraRunning", false]) exitWith {false};

    if (_key isEqualTo 1) exitWith {
        [] call FUNC(stopOrbitCamera);
        true
    };

    false
}];

missionNamespace setVariable ["mkk_ptg_penetrationOrbitControlEHs", [_mouseEH, _wheelEH, _keyEH]];
missionNamespace setVariable ["mkk_ptg_penetrationOrbitControlsAdded", true];
