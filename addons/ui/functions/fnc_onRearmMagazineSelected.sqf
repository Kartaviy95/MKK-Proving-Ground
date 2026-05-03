#include "..\script_component.hpp"
/*
    Stores selected rearm magazine class and updates magazine information panel.
*/
disableSerialization;
params ["_control", "_selectedIndex"];

private _display = ctrlParent _control;
private _infoCtrl = _display displayCtrl 88232;

if (_selectedIndex < 0) exitWith {
    uiNamespace setVariable ["mkk_ptg_rearmSelectedMagazine", ""];
    if (!isNull _infoCtrl) then {
        _infoCtrl ctrlSetStructuredText parseText localize "STR_MKK_PTG_REARM_MAGAZINE_INFO_EMPTY";
    };
};

private _magazine = _control lbData _selectedIndex;
uiNamespace setVariable ["mkk_ptg_rearmSelectedMagazine", _magazine];

private _magCfg = configFile >> "CfgMagazines" >> _magazine;
private _ammo = getText (_magCfg >> "ammo");
private _count = getNumber (_magCfg >> "count");
private _ammoName = _ammo;

private _ammoCfg = configFile >> "CfgAmmo" >> _ammo;
if (isClass _ammoCfg) then {
    private _ammoDisplayName = [getText (_ammoCfg >> "displayName")] call EFUNC(common,localizeString);
    if (_ammoDisplayName != "") then {
        _ammoName = format ["%1 (%2)", _ammoDisplayName, _ammo];
    };
};

_infoCtrl ctrlSetStructuredText parseText format [
    "<t color='#B8E0FF'>%1</t><br/><t size='0.85'>%2: %3<br/>%4: %5<br/>%6: %7</t>",
    localize "STR_MKK_PTG_REARM_MAGAZINE_INFO",
    localize "STR_MKK_PTG_REARM_MAGAZINE_CLASSNAME",
    _magazine,
    localize "STR_MKK_PTG_REARM_MAGAZINE_AMMO",
    _ammoName,
    localize "STR_MKK_PTG_REARM_MAGAZINE_COUNT",
    _count
];
