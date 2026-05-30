#include "..\script_component.hpp"
/*
    Stores the selected vehicle classname.
*/
params [
    ["_className", ""],
    ["_selectedIndex", -1]
];

if (_className isEqualType controlNull) then {
    if (isNull _className || {_selectedIndex < 0}) exitWith {};
    _className = _className lbData _selectedIndex;
};
if !(_className isEqualType "") exitWith {};
if (_className isEqualTo "") exitWith {};

missionNamespace setVariable ["mkk_ptg_currentSelection", _className];
[] call FUNC(refreshStaticAmmoBoxes);
[false] call FUNC(saveVehicleSpawnState);
