#include "..\script_component.hpp"
/*
    Инициализация главного окна полигона.
*/
params ["_display"];

uiNamespace setVariable ["mkk_ptg_display", _display];
missionNamespace setVariable ["mkk_ptg_currentSelection", ""];

[] call FUNC(refreshFilters);
