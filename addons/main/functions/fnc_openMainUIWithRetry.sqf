#include "..\script_component.hpp"
/*
    Opens/toggles the main UI and retries once when the first open attempt
    leaves no main display. Used by the CBA keybind down/up callbacks.
*/
if !(hasInterface) exitWith {false};

params [
    ["_source", "keybind", [""]]
];

private _requestAt = diag_tickTime;
private _hadDisplay = !(isNull (findDisplay 88000));

uiNamespace setVariable ["mkk_ptg_openMainUIHandledAt", _requestAt];
uiNamespace setVariable ["mkk_ptg_openUIRetryRequestedAt", _requestAt];

[] call FUNC(openMainUI);

if !(_hadDisplay) then {
    [_requestAt] spawn {
        params ["_requestAt"];

        uiSleep 0.18;

        if ((uiNamespace getVariable ["mkk_ptg_openUIRetryRequestedAt", -1]) isNotEqualTo _requestAt) exitWith {};
        if !(isNull (findDisplay 88000)) exitWith {};

        uiNamespace setVariable ["mkk_ptg_openMainUIHandledAt", diag_tickTime];
        [] call FUNC(openMainUI);
    };
};

true
