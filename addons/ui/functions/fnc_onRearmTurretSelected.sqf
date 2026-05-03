#include "..\script_component.hpp"
/*
    Handles selected rearm crew position / turret.
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

(_turretRows select _selectedIndex) params ["_name", "_path", "_weapons"];
uiNamespace setVariable ["mkk_ptg_rearmSelectedTurret", _path];
uiNamespace setVariable ["mkk_ptg_rearmSelectedWeapon", ""];
uiNamespace setVariable ["mkk_ptg_rearmSelectedMagazine", ""];
uiNamespace setVariable ["mkk_ptg_rearmCompatibleMagazines", []];

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
