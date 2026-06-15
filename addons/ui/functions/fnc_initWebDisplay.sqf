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

private _wheelEH = _display displayAddEventHandler ["MouseZChanged", {
    params ["_display", "_scroll"];

    if (uiNamespace getVariable ["mkk_ptg_mainDisplayClosing", false]) exitWith {false};
    if !(uiNamespace getVariable ["mkk_ptg_webReady", false]) exitWith {false};

    private _browser = uiNamespace getVariable ["mkk_ptg_webControl", controlNull];
    if (isNull _browser) exitWith {false};

    private _browserPos = ctrlPosition _browser;
    getMousePosition params ["_mouseX", "_mouseY"];
    if (
        _mouseX < (_browserPos # 0)
        || {_mouseX > ((_browserPos # 0) + (_browserPos # 2))}
        || {_mouseY < (_browserPos # 1)}
        || {_mouseY > ((_browserPos # 1) + (_browserPos # 3))}
    ) exitWith {false};

    _browser ctrlWebBrowserAction [
        "ExecJS",
        format ["if (window.PTG && window.PTG.scrollHovered) { window.PTG.scrollHovered(%1); }", _scroll]
    ];
    true
}];
uiNamespace setVariable ["mkk_ptg_webWheelHandlers", [_display, _wheelEH]];

_browser ctrlWebBrowserAction ["LoadFile", "x\ptg\addons\ui\web\main.html"];
