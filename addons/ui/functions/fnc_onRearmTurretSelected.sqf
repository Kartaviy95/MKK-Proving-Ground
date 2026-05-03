#include "..\script_component.hpp"
/*
    Handles selected rearm crew position / turret / pylon.
*/
disableSerialization;
params ["_control", "_selectedIndex"];

private _display = ctrlParent _control;
private _weaponCtrl = _display displayCtrl 88221;
private _magCtrl = _display displayCtrl 88222;
private _infoCtrl = _display displayCtrl 88232;
private _statusCtrl = _display displayCtrl 88233;
lbClear _weaponCtrl;
lbClear _magCtrl;
if (!isNull _infoCtrl) then {
    _infoCtrl ctrlSetStructuredText parseText localize "STR_MKK_PTG_REARM_MAGAZINE_INFO_EMPTY";
};
if (!isNull _statusCtrl) then {
    _statusCtrl ctrlSetStructuredText parseText "";
};

private _turretRows = uiNamespace getVariable ["mkk_ptg_rearmTurrets", []];
if (_selectedIndex < 0 || {_selectedIndex >= count _turretRows}) exitWith {};

(_turretRows select _selectedIndex) params ["_name", "_path", "_weapons", ["_mode", "turret"]];
uiNamespace setVariable ["mkk_ptg_rearmSelectedMode", _mode];
uiNamespace setVariable ["mkk_ptg_rearmSelectedWeapon", ""];
uiNamespace setVariable ["mkk_ptg_rearmSelectedMagazine", ""];
uiNamespace setVariable ["mkk_ptg_rearmCompatibleMagazines", []];

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
        if (_displayName != "") then {_currentName = _displayName};
    };

    private _index = _weaponCtrl lbAdd format [localize "STR_MKK_PTG_REARM_PYLON_CURRENT", _pylonIndex, _currentName];
    _weaponCtrl lbSetData [_index, format ["__PTG_PYLON_%1", _pylonIndex]];
    _weaponCtrl lbSetCurSel 0;
};

uiNamespace setVariable ["mkk_ptg_rearmSelectedTurret", _path];
uiNamespace setVariable ["mkk_ptg_rearmSelectedPylon", -1];
uiNamespace setVariable ["mkk_ptg_rearmSelectedPylonTurret", []];

{
    private _cfg = configFile >> "CfgWeapons" >> _x;
    private _displayName = [getText (_cfg >> "displayName")] call EFUNC(common,localizeString);
    if (_displayName isEqualTo "") then {_displayName = _x};
    private _index = _weaponCtrl lbAdd _displayName;
    _weaponCtrl lbSetData [_index, _x];
} forEach _weapons;

if ((lbSize _weaponCtrl) > 0) then {
    _weaponCtrl lbSetCurSel 0;
};
