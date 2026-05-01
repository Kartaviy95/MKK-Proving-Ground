#include "..\script_component.hpp"
/*
    Sets trajectory line color preset.
*/
params [["_index", 0, [0]]];

private _colors = [
    [0.10, 0.85, 1.00, 0.95],
    [1.00, 0.12, 0.10, 0.95],
    [1.00, 0.86, 0.05, 0.95],
    [0.20, 1.00, 0.25, 0.95],
    [1.00, 0.16, 0.95, 0.95],
    [1.00, 1.00, 1.00, 0.95]
];

private _safeIndex = (_index max 0) min ((count _colors) - 1);
missionNamespace setVariable ["mkk_ptg_trajectoryColorIndex", _safeIndex];
missionNamespace setVariable ["mkk_ptg_trajectoryColor", _colors # _safeIndex];

[] call FUNC(updateTrajectorySettingsMenu);
