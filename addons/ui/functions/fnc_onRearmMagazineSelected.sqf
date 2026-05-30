#include "..\script_component.hpp"
/*
    Stores selected rearm magazine.
*/
disableSerialization;
params [
    ["_selectedIndexOrControl", -1],
    ["_legacyIndex", -1]
];

private _selectedIndex = _selectedIndexOrControl;
if (_selectedIndexOrControl isEqualType controlNull) then {
    _selectedIndex = _legacyIndex;
};
if !(_selectedIndex isEqualType 0) then {_selectedIndex = parseNumber str _selectedIndex;};

private _magazines = uiNamespace getVariable ["mkk_ptg_rearmCompatibleMagazines", []];
if (_selectedIndex < 0 || {_selectedIndex >= count _magazines}) exitWith {
    uiNamespace setVariable ["mkk_ptg_rearmSelectedMagazine", ""];
    uiNamespace setVariable ["mkk_ptg_rearmSelectedMagazineIndex", -1];
};

uiNamespace setVariable ["mkk_ptg_rearmSelectedMagazine", _magazines # _selectedIndex];
uiNamespace setVariable ["mkk_ptg_rearmSelectedMagazineIndex", _selectedIndex];
