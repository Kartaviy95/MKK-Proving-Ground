#include "..\script_component.hpp"
/*
    Завершает работу главного окна и сохраняет состояние экрана техники.
*/
[true] call FUNC(saveVehicleSpawnState);

private _wheelHandlers = uiNamespace getVariable ["mkk_ptg_webWheelHandlers", []];
if ((count _wheelHandlers) >= 2) then {
    private _display = _wheelHandlers # 0;
    private _wheelEH = _wheelHandlers # 1;
    if !(isNull _display) then {
        _display displayRemoveEventHandler ["MouseZChanged", _wheelEH];
    };
};
uiNamespace setVariable ["mkk_ptg_webWheelHandlers", []];

uiNamespace setVariable ["mkk_ptg_display", displayNull];
uiNamespace setVariable ["mkk_ptg_webControl", controlNull];
uiNamespace setVariable ["mkk_ptg_webReady", false];
uiNamespace setVariable ["mkk_ptg_mainDisplayClosing", false];
uiNamespace setVariable ["mkk_ptg_mainDisplayOpenQueued", false];
uiNamespace setVariable ["mkk_ptg_vehicleFiltersReady", false];
