#include "..\script_component.hpp"
/*
    Обновляет текущий выбор и карточку техники.
*/
params [
    ["_control", controlNull],
    ["_selectedIndex", -1]
];

if (isNull _control) exitWith {};
if (_selectedIndex < 0) exitWith {};

private _className = _control lbData _selectedIndex;
missionNamespace setVariable ["mkk_ptg_currentSelection", _className];

[] call FUNC(updateVehicleCard);
