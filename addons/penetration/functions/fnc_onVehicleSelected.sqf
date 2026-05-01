#include "..\script_component.hpp"
/*
    Сохраняет выбранную цель теста пробития и обновляет изображение.
*/
params [
    ["_control", controlNull],
    ["_selectedIndex", -1]
];

if (isNull _control || {_selectedIndex < 0}) exitWith {
    missionNamespace setVariable ["mkk_ptg_penetrationVehicleClass", ""];
    [] call FUNC(updateVehiclePreview);
};

private _className = _control lbData _selectedIndex;
missionNamespace setVariable ["mkk_ptg_penetrationVehicleClass", _className];

[] call FUNC(updateVehiclePreview);
