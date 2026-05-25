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
uiNamespace setVariable [_controlVar, _browser];
uiNamespace setVariable [_readyVar, false];
_browser setVariable ["mkk_ptg_webSurface", _surface];

_browser ctrlAddEventHandler ["PageLoaded", {
    params ["_control"];
    private _surface = _control getVariable ["mkk_ptg_webSurface", "penetration"];
    uiNamespace setVariable [format ["mkk_ptg_%1WebReady", _surface], true];
    [_surface] call FUNC(pushWebState);
}];

_browser ctrlAddEventHandler ["JSDialog", {
    _this call FUNC(handleWebEvent)
}];

_browser ctrlWebBrowserAction ["LoadFile", "x\ptg\addons\ui\web\main.html"];
