#include "..\script_component.hpp"
/*
    Initializes the local HTML presentation and its message bridge.
*/
params ["_display"];

if !(hasInterface) exitWith {};
if (isNull _display) exitWith {};

private _browser = _display displayCtrl 88090;
if (isNull _browser) exitWith {};

uiNamespace setVariable ["mkk_ptg_webControl", _browser];
uiNamespace setVariable ["mkk_ptg_webReady", false];

_browser ctrlAddEventHandler ["PageLoaded", {
    params ["_control"];
    if (uiNamespace getVariable ["mkk_ptg_mainDisplayClosing", false]) exitWith {};
    uiNamespace setVariable ["mkk_ptg_webControl", _control];
    uiNamespace setVariable ["mkk_ptg_webReady", true];
    [] call FUNC(pushWebState);
}];

_browser ctrlAddEventHandler ["JSDialog", {
    _this call FUNC(handleWebEvent)
}];

_browser ctrlWebBrowserAction ["LoadFile", "x\ptg\addons\ui\web\main.html"];
