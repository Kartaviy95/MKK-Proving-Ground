#include "..\script_component.hpp"
/*
    Показывает локальный hint и очищает его после короткой задержки.
*/
params [
    ["_text", "", [""]],
    ["_duration", 2, [0]]
];

if !(hasInterface) exitWith {};

_duration = 2;

private _token = (uiNamespace getVariable ["mkk_ptg_timedHintToken", 0]) + 1;
uiNamespace setVariable ["mkk_ptg_timedHintToken", _token];

hint _text;

[_token, _duration] spawn {
    params ["_token", "_duration"];

    uiSleep _duration;

    if ((uiNamespace getVariable ["mkk_ptg_timedHintToken", -1]) isEqualTo _token) then {
        hintSilent "";
    };
};
