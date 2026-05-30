#include "..\script_component.hpp"
/*
    Selects a rearm weapon and builds compatible magazine rows.
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

uiNamespace setVariable ["mkk_ptg_rearmMagazineRows", []];
uiNamespace setVariable ["mkk_ptg_rearmSelectedWeaponIndex", _selectedIndex];
uiNamespace setVariable ["mkk_ptg_rearmSelectedMagazineIndex", -1];
uiNamespace setVariable ["mkk_ptg_rearmSelectedMagazine", ""];
uiNamespace setVariable ["mkk_ptg_rearmCompatibleMagazines", []];

if (_selectedIndex < 0) exitWith {
    uiNamespace setVariable ["mkk_ptg_rearmSelectedWeapon", ""];
};

private _mode = uiNamespace getVariable ["mkk_ptg_rearmSelectedMode", "turret"];
if (_mode isEqualTo "pylon") exitWith {
    private _vehicle = uiNamespace getVariable ["mkk_ptg_rearmVehicle", objNull];
    private _pylonIndex = uiNamespace getVariable ["mkk_ptg_rearmSelectedPylon", -1];
    if (isNull _vehicle || {_pylonIndex < 1}) exitWith {};

    private _magazines = _vehicle getCompatiblePylonMagazines _pylonIndex;
    private _currentMagazine = (getPylonMagazines _vehicle) param [_pylonIndex - 1, ""];
    if (_currentMagazine isNotEqualTo "" && {!(_currentMagazine in _magazines)}) then {
        _magazines pushBack _currentMagazine;
    };
    _magazines sort true;
    uiNamespace setVariable ["mkk_ptg_rearmSelectedWeapon", format ["__PTG_PYLON_%1", _pylonIndex]];
    uiNamespace setVariable ["mkk_ptg_rearmCompatibleMagazines", _magazines];

    private _magRows = [];
    {
        private _cfg = configFile >> "CfgMagazines" >> _x;
        private _displayName = [getText (_cfg >> "displayName")] call EFUNC(common,localizeString);
        if (_displayName isEqualTo "") then {_displayName = _x};
        _magRows pushBack [str _forEachIndex, _displayName, _x];
    } forEach _magazines;
    uiNamespace setVariable ["mkk_ptg_rearmMagazineRows", _magRows];

    if (_magRows isNotEqualTo []) then {
        [0] call FUNC(onRearmMagazineSelected);
    };
};

private _turretRows = uiNamespace getVariable ["mkk_ptg_rearmTurrets", []];
private _slotIndex = uiNamespace getVariable ["mkk_ptg_rearmSelectedSlotIndex", -1];
if (_slotIndex < 0 || {_slotIndex >= count _turretRows}) exitWith {};

private _weapons = (_turretRows # _slotIndex) # 2;
if (_selectedIndex >= count _weapons) exitWith {};

private _weapon = _weapons # _selectedIndex;
uiNamespace setVariable ["mkk_ptg_rearmSelectedWeapon", _weapon];

private _weaponCfg = configFile >> "CfgWeapons" >> _weapon;
private _magazines = [];

private _fncAddMagazine = {
    params ["_magazine"];
    if (_magazine isNotEqualTo "" && {!(_magazine in _magazines)} && {isClass (configFile >> "CfgMagazines" >> _magazine)}) then {
        _magazines pushBack _magazine;
    };
};

private _fncAddMagazineWellMagazines = {
    params ["_cfg"];

    {
        if (isArray _x) then {
            {[_x] call _fncAddMagazine} forEach getArray _x;
        };

        if (isClass _x) then {
            [_x] call _fncAddMagazineWellMagazines;
        };
    } forEach configProperties [_cfg, "true", true];
};

{[_x] call _fncAddMagazine} forEach getArray (_weaponCfg >> "magazines");

{
    private _muzzleCfg = if (_x isEqualTo "this") then {_weaponCfg} else {_weaponCfg >> _x};
    {[_x] call _fncAddMagazine} forEach getArray (_muzzleCfg >> "magazines");
} forEach getArray (_weaponCfg >> "muzzles");

{
    private _wellCfg = configFile >> "CfgMagazineWells" >> _x;
    if (isClass _wellCfg) then {
        [_wellCfg] call _fncAddMagazineWellMagazines;
    };
} forEach getArray (_weaponCfg >> "magazineWell");

_magazines sort true;
uiNamespace setVariable ["mkk_ptg_rearmCompatibleMagazines", _magazines];

private _magRows = [];
{
    private _cfg = configFile >> "CfgMagazines" >> _x;
    private _displayName = [getText (_cfg >> "displayName")] call EFUNC(common,localizeString);
    if (_displayName isEqualTo "") then {_displayName = _x};
    _magRows pushBack [str _forEachIndex, _displayName, _x];
} forEach _magazines;

uiNamespace setVariable ["mkk_ptg_rearmMagazineRows", _magRows];
if (_magRows isNotEqualTo []) then {
    [0] call FUNC(onRearmMagazineSelected);
};
