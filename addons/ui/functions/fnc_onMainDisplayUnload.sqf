#include "..\script_component.hpp"
/*
    Завершает работу главного окна и сохраняет состояние экрана техники.
*/
[true] call FUNC(saveVehicleSpawnState);
uiNamespace setVariable ["mkk_ptg_display", displayNull];
