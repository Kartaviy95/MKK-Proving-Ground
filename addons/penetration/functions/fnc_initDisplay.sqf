#include "..\script_component.hpp"
/*
    Инициализация окна теста пробития.
*/
params ["_display"];

uiNamespace setVariable ["mkk_ptg_penetrationDisplay", _display];
missionNamespace setVariable ["mkk_ptg_penetrationVehicleClass", ""];
missionNamespace setVariable ["mkk_ptg_penetrationAmmoClass", ""];

[] call FUNC(refreshVehicleList);
[] call FUNC(refreshAmmoList);
[] call FUNC(updateReport);
