#include "..\script_component.hpp"
/*
    Debounces hidden native search edits before refreshing the browser state.
*/
params [
    ["_kind", "vehicle", [""]]
];

if !(hasInterface) exitWith {};

private _keyAt = format ["mkk_ptg_%1SearchRefreshAt", _kind];
private _keyQueued = format ["mkk_ptg_%1SearchRefreshQueued", _kind];

uiNamespace setVariable [_keyAt, diag_tickTime + 0.12];
if (uiNamespace getVariable [_keyQueued, false]) exitWith {};
uiNamespace setVariable [_keyQueued, true];

[_kind, _keyAt, _keyQueued] spawn {
    params ["_kind", "_keyAt", "_keyQueued"];

    waitUntil {
        isNull (uiNamespace getVariable ["mkk_ptg_display", displayNull])
        || {diag_tickTime >= (uiNamespace getVariable [_keyAt, 0])}
    };

    uiNamespace setVariable [_keyQueued, false];

    if (isNull (uiNamespace getVariable ["mkk_ptg_display", displayNull])) exitWith {};

    if (_kind isEqualTo "target") then {
        [] call FUNC(refreshTargetList);
    } else {
        [] call FUNC(refreshVehicleList);
    };

    [] call FUNC(pushWebState);
};
