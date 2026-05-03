#include "..\script_component.hpp"
/*
    Requests global clearing of all compatible magazines for the selected rearm weapon.
*/
private _vehicle = uiNamespace getVariable ["mkk_ptg_rearmVehicle", objNull];
private _turret = uiNamespace getVariable ["mkk_ptg_rearmSelectedTurret", []];
private _weapon = uiNamespace getVariable ["mkk_ptg_rearmSelectedWeapon", ""];
private _magazines = uiNamespace getVariable ["mkk_ptg_rearmCompatibleMagazines", []];

if (isNull _vehicle || {_vehicle != objectParent player}) exitWith {
    [localize "STR_MKK_PTG_REARM_ENTER_VEHICLE"] call EFUNC(main,showTimedHint);
};

if (_weapon isEqualTo "") exitWith {
    [localize "STR_MKK_PTG_REARM_SELECT_WEAPON"] call EFUNC(main,showTimedHint);
};

if (_magazines isEqualTo []) exitWith {
    [localize "STR_MKK_PTG_REARM_NO_MAGAZINES"] call EFUNC(main,showTimedHint);
};

[_vehicle, _turret, _magazines] remoteExecCall [QFUNC(clearRearmWeapon), _vehicle];
[localize "STR_MKK_PTG_REARM_WEAPON_CLEARED"] call EFUNC(main,showTimedHint);
