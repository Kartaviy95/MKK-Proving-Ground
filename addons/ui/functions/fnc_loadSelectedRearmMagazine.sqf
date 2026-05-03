#include "..\script_component.hpp"
/*
    Adds and loads the selected magazine into the selected vehicle turret weapon.
*/
private _vehicle = uiNamespace getVariable ["mkk_ptg_rearmVehicle", objNull];
private _turret = uiNamespace getVariable ["mkk_ptg_rearmSelectedTurret", []];
private _weapon = uiNamespace getVariable ["mkk_ptg_rearmSelectedWeapon", ""];
private _magazine = uiNamespace getVariable ["mkk_ptg_rearmSelectedMagazine", ""];

if (isNull _vehicle || {_vehicle != objectParent player}) exitWith {
    [localize "STR_MKK_PTG_REARM_ENTER_VEHICLE"] call EFUNC(main,showTimedHint);
};

if (_weapon isEqualTo "") exitWith {
    [localize "STR_MKK_PTG_REARM_SELECT_WEAPON"] call EFUNC(main,showTimedHint);
};

if (_magazine isEqualTo "") exitWith {
    [localize "STR_MKK_PTG_REARM_SELECT_MAGAZINE"] call EFUNC(main,showTimedHint);
};

_vehicle addMagazineTurret [_magazine, _turret];
_vehicle loadMagazine [_turret, _weapon, _magazine];

private _displayName = [getText (configFile >> "CfgMagazines" >> _magazine >> "displayName")] call EFUNC(common,localizeString);
if (_displayName isEqualTo "") then {_displayName = _magazine};
[format [localize "STR_MKK_PTG_REARM_LOADED", _displayName]] call EFUNC(main,showTimedHint);
