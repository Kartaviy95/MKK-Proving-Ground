#include "..\script_component.hpp"
/*
    Инициализация главного окна полигона.
*/
params ["_display"];

uiNamespace setVariable ["mkk_ptg_display", _display];
missionNamespace setVariable ["mkk_ptg_currentSelection", ""];

(_display displayCtrl 88015) ctrlSetText str (missionNamespace getVariable ["mkk_ptg_spawnDefaultDistance", 30]);
(_display displayCtrl 88016) ctrlSetText "0";

[] call FUNC(refreshFilters);
[] call FUNC(showDashboardView);
