#include "..\script_component.hpp"
/*
    Сохраняет выбранный боеприпас теста пробития и обновляет его параметры.
*/
params [
    ["_control", controlNull],
    ["_selectedIndex", -1]
];

if (isNull _control || {_selectedIndex < 0}) exitWith {
    missionNamespace setVariable ["mkk_ptg_penetrationAmmoClass", ""];
    [] call FUNC(updateAmmoInfo);
};

private _ammoClass = _control lbData _selectedIndex;
missionNamespace setVariable ["mkk_ptg_penetrationAmmoClass", _ammoClass];

[] call FUNC(updateAmmoInfo);
