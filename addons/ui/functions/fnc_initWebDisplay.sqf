#include "..\script_component.hpp"
/*
    Initializes the local HTML presentation and its message bridge.
*/
params ["_display"];

if !(hasInterface) exitWith {};
if (isNull _display) exitWith {};

private _browser = _display displayCtrl 88090;
if (isNull _browser) exitWith {};

// Keep native controls as the SQF state model while HTML owns presentation.
for "_idc" from 88001 to 88499 do {
    if (_idc isNotEqualTo 88090) then {
        private _control = _display displayCtrl _idc;
        if !(isNull _control) then {
            _control ctrlShow false;
        };
    };
};

uiNamespace setVariable ["mkk_ptg_webControl", _browser];
uiNamespace setVariable ["mkk_ptg_webReady", false];

_browser ctrlAddEventHandler ["PageLoaded", {
    params ["_control"];
    uiNamespace setVariable ["mkk_ptg_webControl", _control];
    uiNamespace setVariable ["mkk_ptg_webReady", true];
    [] call FUNC(pushWebState);
}];

_browser ctrlAddEventHandler ["JSDialog", {
    _this call FUNC(handleWebEvent)
}];

_browser ctrlWebBrowserAction ["LoadFile", "x\ptg\addons\ui\web\main.html"];
