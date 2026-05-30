#include "..\script_component.hpp"
/*
    Stores the selected ammo box for the selected static weapon.
*/
params [
    ["_boxClass", ""],
    ["_selectedIndex", -1]
];

if (_boxClass isEqualType controlNull) then {
    if (isNull _boxClass || {_selectedIndex < 0}) exitWith {};
    _boxClass = _boxClass lbData _selectedIndex;
};
if !(_boxClass isEqualType "") then {_boxClass = "";};

missionNamespace setVariable ["mkk_ptg_currentAmmoBoxSelection", _boxClass];
[false] call FUNC(saveVehicleSpawnState);
