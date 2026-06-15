#include "..\script_component.hpp"
/*
    Removes the browser mouse wheel bridge for a penetration web surface.
*/
params [["_surface", "penetration", [""]]];

private _handlersVar = format ["mkk_ptg_%1WebWheelHandlers", _surface];
private _wheelHandlers = uiNamespace getVariable [_handlersVar, []];

if ((count _wheelHandlers) >= 2) then {
    private _display = _wheelHandlers # 0;
    private _wheelEH = _wheelHandlers # 1;
    if !(isNull _display) then {
        _display displayRemoveEventHandler ["MouseZChanged", _wheelEH];
    };
};

uiNamespace setVariable [_handlersVar, []];
