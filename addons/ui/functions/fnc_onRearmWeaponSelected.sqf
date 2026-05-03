#include "..\script_component.hpp"
/*
    Handles selected rearm weapon and lists compatible magazines from CfgWeapons.
*/
disableSerialization;
params ["_control", "_selectedIndex"];

private _display = ctrlParent _control;
private _magCtrl = _display displayCtrl 88222;
private _infoCtrl = _display displayCtrl 88232;
private _statusCtrl = _display displayCtrl 88233;
lbClear _magCtrl;
uiNamespace setVariable ["mkk_ptg_rearmSelectedMagazine", ""];
uiNamespace setVariable ["mkk_ptg_rearmCompatibleMagazines", []];

if (!isNull _infoCtrl) then {
    _infoCtrl ctrlSetStructuredText parseText localize "STR_MKK_PTG_REARM_MAGAZINE_INFO_EMPTY";
};
if (!isNull _statusCtrl) then {
    _statusCtrl ctrlSetStructuredText parseText "";
};

if (_selectedIndex < 0) exitWith {
    uiNamespace setVariable ["mkk_ptg_rearmSelectedWeapon", ""];
};

private _weapon = _control lbData _selectedIndex;
uiNamespace setVariable ["mkk_ptg_rearmSelectedWeapon", _weapon];

private _weaponCfg = configFile >> "CfgWeapons" >> _weapon;
private _magazines = [];

private _fncAddMagazine = {
    params ["_magazine"];
    if (_magazine != "" && {!(_magazine in _magazines)} && {isClass (configFile >> "CfgMagazines" >> _magazine)}) then {
        _magazines pushBack _magazine;
    };
};

// Use the selected weapon config as the source of truth. Vehicle magazines are intentionally not read here.
{[_x] call _fncAddMagazine} forEach getArray (_weaponCfg >> "magazines");

{
    private _muzzleCfg = if (_x isEqualTo "this") then {_weaponCfg} else {_weaponCfg >> _x};
    {[_x] call _fncAddMagazine} forEach getArray (_muzzleCfg >> "magazines");
} forEach getArray (_weaponCfg >> "muzzles");

{
    private _wellCfg = configFile >> "CfgMagazineWells" >> _x;
    if (isClass _wellCfg) then {
        {[_x] call _fncAddMagazine} forEach getArray (_wellCfg >> "magazines");
    };
} forEach getArray (_weaponCfg >> "magazineWell");

_magazines sort true;
uiNamespace setVariable ["mkk_ptg_rearmCompatibleMagazines", _magazines];

{
    private _cfg = configFile >> "CfgMagazines" >> _x;
    private _displayName = [getText (_cfg >> "displayName")] call EFUNC(common,localizeString);
    if (_displayName isEqualTo "") then {_displayName = _x};
    private _index = _magCtrl lbAdd _displayName;
    _magCtrl lbSetData [_index, _x];
} forEach _magazines;

if ((lbSize _magCtrl) > 0) then {
    if (!isNull _statusCtrl) then {
        _statusCtrl ctrlSetStructuredText parseText "";
    };
    _magCtrl lbSetCurSel 0;
} else {
    if (!isNull _statusCtrl) then {
        _statusCtrl ctrlSetStructuredText parseText format ["<t color='#FFB8B8'>%1</t>", localize "STR_MKK_PTG_REARM_NO_MAGAZINES"];
    };
};
