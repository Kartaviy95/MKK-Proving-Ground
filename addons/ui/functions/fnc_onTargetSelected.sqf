#include "..\script_component.hpp"
/*
    Stores selected target classname.
*/
params [
    ["_className", ""],
    ["_selectedIndex", -1]
];

if (_className isEqualType controlNull) then {
    _className = if (_selectedIndex >= 0) then {_className lbData _selectedIndex} else {""};
};
if !(_className isEqualType "") then {_className = "";};
missionNamespace setVariable ["mkk_ptg_targetSelection", _className];
