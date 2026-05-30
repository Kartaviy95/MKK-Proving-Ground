#include "..\script_component.hpp"
/*
    Selects a rearm slot and builds its weapon rows.
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

uiNamespace setVariable ["mkk_ptg_rearmWeaponRows", []];
uiNamespace setVariable ["mkk_ptg_rearmMagazineRows", []];
uiNamespace setVariable ["mkk_ptg_rearmSelectedSlotIndex", _selectedIndex];
uiNamespace setVariable ["mkk_ptg_rearmSelectedWeaponIndex", -1];
uiNamespace setVariable ["mkk_ptg_rearmSelectedMagazineIndex", -1];

private _turretRows = uiNamespace getVariable ["mkk_ptg_rearmTurrets", []];
if (_selectedIndex < 0 || {_selectedIndex >= count _turretRows}) exitWith {};

(_turretRows select _selectedIndex) params ["_name", "_path", "_weapons", ["_mode", "turret"]];
uiNamespace setVariable ["mkk_ptg_rearmSelectedMode", _mode];
uiNamespace setVariable ["mkk_ptg_rearmSelectedWeapon", ""];
uiNamespace setVariable ["mkk_ptg_rearmSelectedMagazine", ""];
uiNamespace setVariable ["mkk_ptg_rearmCompatibleMagazines", []];

private _weaponRows = [];
if (_mode isEqualTo "pylon") exitWith {
    _path params ["_pylonIndex", ["_pylonTurret", []]];
    uiNamespace setVariable ["mkk_ptg_rearmSelectedTurret", _pylonTurret];
    uiNamespace setVariable ["mkk_ptg_rearmSelectedPylon", _pylonIndex];
    uiNamespace setVariable ["mkk_ptg_rearmSelectedPylonTurret", _pylonTurret];

    private _currentMagazine = _weapons param [0, ""];
    private _currentName = _currentMagazine;
    if (_currentName isEqualTo "") then {
        _currentName = localize "STR_MKK_PTG_REARM_PYLON_EMPTY";
    } else {
        private _cfg = configFile >> "CfgMagazines" >> _currentMagazine;
        private _displayName = [getText (_cfg >> "displayName")] call EFUNC(common,localizeString);
        if (_displayName isNotEqualTo "") then {_currentName = _displayName};
    };

    _weaponRows pushBack ["0", format [localize "STR_MKK_PTG_REARM_PYLON_CURRENT", _pylonIndex, _currentName], ""];
    uiNamespace setVariable ["mkk_ptg_rearmWeaponRows", _weaponRows];
    [0] call FUNC(onRearmWeaponSelected);
};

uiNamespace setVariable ["mkk_ptg_rearmSelectedTurret", _path];
uiNamespace setVariable ["mkk_ptg_rearmSelectedPylon", -1];
uiNamespace setVariable ["mkk_ptg_rearmSelectedPylonTurret", []];

{
    private _cfg = configFile >> "CfgWeapons" >> _x;
    private _displayName = [getText (_cfg >> "displayName")] call EFUNC(common,localizeString);
    if (_displayName isEqualTo "") then {_displayName = _x};
    _weaponRows pushBack [str _forEachIndex, _displayName, _x];
} forEach _weapons;

uiNamespace setVariable ["mkk_ptg_rearmWeaponRows", _weaponRows];
if (_weaponRows isNotEqualTo []) then {
    [0] call FUNC(onRearmWeaponSelected);
};
