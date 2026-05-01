#include "..\script_component.hpp"
/*
    Sets trajectory line color preset.
*/
params [["_index", 0, [0]]];

private _colors = [
    [0.10, 0.85, 1.00, 1.00],
    [1.00, 0.00, 0.00, 1.00],
    [1.00, 1.00, 0.00, 1.00],
    [0.20, 1.00, 0.25, 1.00],
    [1.00, 0.00, 1.00, 1.00],
    [1.00, 1.00, 1.00, 1.00]
];

private _safeIndex = (_index max 0) min ((count _colors) - 1);
// store globally (broadcast) so all clients use same color for Draw3D
missionNamespace setVariable ["mkk_ptg_trajectoryColorIndex", _safeIndex, true];
missionNamespace setVariable ["mkk_ptg_trajectoryColor", _colors # _safeIndex, true];

// mirror into uiNamespace so UI and local Draw3D handlers see the selection reliably
uiNamespace setVariable ["mkk_ptg_trajectoryColorIndex", _safeIndex];
uiNamespace setVariable ["mkk_ptg_trajectoryColor", _colors # _safeIndex];

// debug hint to confirm selection (temporary)
// hint format ["Trajectory color set: %1 (idx %2)", _colors # _safeIndex, _safeIndex];

[] call FUNC(updateTrajectorySettingsMenu);
