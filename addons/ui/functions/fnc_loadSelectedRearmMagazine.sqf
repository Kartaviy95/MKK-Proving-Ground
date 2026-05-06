#include "..\script_component.hpp"
/*
    Добавляет и заряжает выбранный магазин в выбранное оружие турели техники.
*/
private _vehicle = uiNamespace getVariable ["mkk_ptg_rearmVehicle", objNull];
private _turret = uiNamespace getVariable ["mkk_ptg_rearmSelectedTurret", []];
private _weapon = uiNamespace getVariable ["mkk_ptg_rearmSelectedWeapon", ""];
private _magazine = uiNamespace getVariable ["mkk_ptg_rearmSelectedMagazine", ""];
private _mode = uiNamespace getVariable ["mkk_ptg_rearmSelectedMode", "turret"];

if (isNull _vehicle || {_vehicle != objectParent player}) exitWith {
    [localize "STR_MKK_PTG_REARM_ENTER_VEHICLE"] call EFUNC(main,showTimedHint);
};

if (_weapon isEqualTo "" && {_mode != "pylon"}) exitWith {
    [localize "STR_MKK_PTG_REARM_SELECT_WEAPON"] call EFUNC(main,showTimedHint);
};

if (_magazine isEqualTo "") exitWith {
    [localize "STR_MKK_PTG_REARM_SELECT_MAGAZINE"] call EFUNC(main,showTimedHint);
};

if (_mode isEqualTo "pylon") then {
    private _pylonIndex = uiNamespace getVariable ["mkk_ptg_rearmSelectedPylon", -1];
    private _pylonTurret = uiNamespace getVariable ["mkk_ptg_rearmSelectedPylonTurret", []];
    if (_pylonIndex < 1) exitWith {};
    [_vehicle, _pylonIndex, _magazine, _pylonTurret] call FUNC(applyPylonLoadout);
} else {
    private _targetUnit = [_vehicle, _turret] call FUNC(getRearmExecutionTarget);
    if (!isNull _targetUnit && {!local _targetUnit}) then {
        [_vehicle, _turret, _weapon, _magazine] remoteExecCall [QFUNC(applyRearmMagazine), _targetUnit];
    } else {
        [_vehicle, _turret, _weapon, _magazine] call FUNC(applyRearmMagazine);
    };
};

private _displayName = [getText (configFile >> "CfgMagazines" >> _magazine >> "displayName")] call EFUNC(common,localizeString);
if (_displayName isEqualTo "") then {_displayName = _magazine};
[format [localize "STR_MKK_PTG_REARM_LOADED", _displayName]] call EFUNC(main,showTimedHint);
[] call FUNC(refreshRearmOverlay);
