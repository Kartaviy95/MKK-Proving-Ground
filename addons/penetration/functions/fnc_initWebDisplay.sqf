#include "..\script_component.hpp"
/*
    Connects penetration tools to the shared browser presentation.
*/
params ["_display", ["_surface", "penetration", [""]]];

if !(hasInterface) exitWith {};
if (isNull _display) exitWith {};

private _idc = [88990, 89090] select (_surface isEqualTo "explosion");
private _browser = _display displayCtrl _idc;
if (isNull _browser) exitWith {};

// Native controls still store selections; only the map remains visual in explosion mode.
if (_surface isEqualTo "explosion") then {
    {
        private _control = _display displayCtrl _x;
        if !(isNull _control) then {
            _control ctrlShow false;
        };
    } forEach [89001, 89002, 89010, 89011, 89020, 89030, 89031, 89032, 89050, 89051];
} else {
    for "_legacyIdc" from 88901 to 88989 do {
        private _control = _display displayCtrl _legacyIdc;
        if !(isNull _control) then {
            _control ctrlShow false;
        };
    };
};

private _controlVar = format ["mkk_ptg_%1WebControl", _surface];
private _readyVar = format ["mkk_ptg_%1WebReady", _surface];
private _wheelHandlersVar = format ["mkk_ptg_%1WebWheelHandlers", _surface];
uiNamespace setVariable [_controlVar, _browser];
uiNamespace setVariable [_readyVar, false];
[_surface] call FUNC(cleanupWebWheelHandlers);
_browser setVariable ["mkk_ptg_webSurface", _surface];
_display setVariable ["mkk_ptg_webSurface", _surface];

_browser ctrlAddEventHandler ["PageLoaded", {
    params ["_control"];
    private _surface = _control getVariable ["mkk_ptg_webSurface", "penetration"];
    uiNamespace setVariable [format ["mkk_ptg_%1WebReady", _surface], true];
    [_surface] call FUNC(pushWebState);
}];

_browser ctrlAddEventHandler ["JSDialog", {
    _this call FUNC(handleWebEvent)
}];

private _wheelEH = _display displayAddEventHandler ["MouseZChanged", {
    params ["_display", "_scroll"];

    private _surface = _display getVariable ["mkk_ptg_webSurface", "penetration"];
    if !(uiNamespace getVariable [format ["mkk_ptg_%1WebReady", _surface], false]) exitWith {false};

    private _browser = uiNamespace getVariable [format ["mkk_ptg_%1WebControl", _surface], controlNull];
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
uiNamespace setVariable [_wheelHandlersVar, [_display, _wheelEH]];

_browser ctrlWebBrowserAction ["LoadFile", "x\ptg\addons\ui\web\main.html"];
