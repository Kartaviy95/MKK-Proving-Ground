#include "..\script_component.hpp"
/*
    Инициализация главного окна полигона.
*/
params ["_display"];

uiNamespace setVariable ["mkk_ptg_display", _display];
[_display] call EFUNC(common,applyDisplayScale);
missionNamespace setVariable ["mkk_ptg_currentSelection", ""];

(_display displayCtrl 88005) ctrlSetText format [localize "STR_MKK_PTG_VERSION", QUOTE(VERSION_STR)];
(_display displayCtrl 88015) ctrlSetText str (missionNamespace getVariable ["mkk_ptg_spawnDefaultDistance", 10]);
(_display displayCtrl 88016) ctrlSetText "0";

[] call FUNC(refreshFilters);
[] call FUNC(initInterfaceSizeCombo);
[] call FUNC(showDashboardView);
