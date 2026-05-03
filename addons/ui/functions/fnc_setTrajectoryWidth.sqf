#include "..\script_component.hpp"
/*
    Задает толщину линии траектории.
*/
params [["_width", 3, [0]]];

private _safeWidth = (_width max 1) min 10;
missionNamespace setVariable ["mkk_ptg_trajectoryLineWidth", _safeWidth];

[] call FUNC(updateTrajectorySettingsMenu);
