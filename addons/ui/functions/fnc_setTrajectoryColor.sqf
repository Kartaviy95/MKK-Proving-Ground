#include "..\script_component.hpp"
/*
    Задает preset цвета линии траектории.
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
// сохранить глобально (broadcast), чтобы все клиенты использовали один цвет для Draw3D
missionNamespace setVariable ["mkk_ptg_trajectoryColorIndex", _safeIndex, true];
missionNamespace setVariable ["mkk_ptg_trajectoryColor", _colors # _safeIndex, true];

// продублировать в uiNamespace, чтобы UI и локальные Draw3D handlers надежно видели выбор
uiNamespace setVariable ["mkk_ptg_trajectoryColorIndex", _safeIndex];
uiNamespace setVariable ["mkk_ptg_trajectoryColor", _colors # _safeIndex];

// отладочная подсказка для подтверждения выбора (временно)
// формат подсказки: ["Цвет траектории установлен: %1 (idx %2)", _colors # _safeIndex, _safeIndex];

[] call FUNC(updateTrajectorySettingsMenu);
