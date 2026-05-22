#include "..\script_component.hpp"
/*
    Запоминает выбранный ammo box для выбранной статики.
*/
params [
    ["_control", controlNull],
    ["_selectedIndex", -1]
];

if (isNull _control) exitWith {};
if (_selectedIndex < 0) exitWith {};

missionNamespace setVariable ["mkk_ptg_currentAmmoBoxSelection", _control lbData _selectedIndex];
[false] call FUNC(saveVehicleSpawnState);
