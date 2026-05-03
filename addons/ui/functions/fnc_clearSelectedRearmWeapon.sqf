#include "..\script_component.hpp"
/*
    Запрашивает глобальную очистку всех совместимых магазинов выбранного оружия перевооружения.
*/
private _vehicle = uiNamespace getVariable ["mkk_ptg_rearmVehicle", objNull];
private _turret = uiNamespace getVariable ["mkk_ptg_rearmSelectedTurret", []];
private _weapon = uiNamespace getVariable ["mkk_ptg_rearmSelectedWeapon", ""];
private _magazines = uiNamespace getVariable ["mkk_ptg_rearmCompatibleMagazines", []];
private _mode = uiNamespace getVariable ["mkk_ptg_rearmSelectedMode", "turret"];

if (isNull _vehicle || {_vehicle != objectParent player}) exitWith {
    [localize "STR_MKK_PTG_REARM_ENTER_VEHICLE"] call EFUNC(main,showTimedHint);
};

if (_mode isEqualTo "pylon") exitWith {
    private _pylonIndex = uiNamespace getVariable ["mkk_ptg_rearmSelectedPylon", -1];
    private _pylonTurret = uiNamespace getVariable ["mkk_ptg_rearmSelectedPylonTurret", []];
    if (_pylonIndex < 1) exitWith {};
    [_vehicle, _pylonIndex, "", _pylonTurret] call FUNC(applyPylonLoadout);
    [localize "STR_MKK_PTG_REARM_PYLON_CLEARED"] call EFUNC(main,showTimedHint);
    [] call FUNC(refreshRearmOverlay);
};

if (_weapon isEqualTo "") exitWith {
    [localize "STR_MKK_PTG_REARM_SELECT_WEAPON"] call EFUNC(main,showTimedHint);
};

if (_magazines isEqualTo []) exitWith {
    [localize "STR_MKK_PTG_REARM_NO_MAGAZINES"] call EFUNC(main,showTimedHint);
};

[_vehicle, _turret, _magazines] remoteExecCall [QFUNC(clearRearmWeapon), _vehicle];
[localize "STR_MKK_PTG_REARM_WEAPON_CLEARED"] call EFUNC(main,showTimedHint);
