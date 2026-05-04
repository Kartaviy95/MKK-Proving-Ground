#include "..\script_component.hpp"
/*
    Задает толщину линии траектории.
*/
params [["_width", 3, [0]]];

private _safeWidth = (_width max 1) min 10;
missionNamespace setVariable ["mkk_ptg_trajectoryLineWidth", _safeWidth];

if !(isNull (findDisplay 88800)) exitWith {
    [] call FUNC(updateTrajectorySettingsMenu);
};

[] call FUNC(updateTrajectorySettingsMenu);
