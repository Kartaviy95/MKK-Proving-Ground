#include "..\script_component.hpp"
/*
    Updates selected ammo info for the explosion tool.
*/
private _display = uiNamespace getVariable ["mkk_ptg_explosionDisplay", displayNull];
if (isNull _display) exitWith {};

private _ctrlInfo = _display displayCtrl 89030;
private _ammoClass = missionNamespace getVariable ["mkk_ptg_explosionAmmoClass", ""];
if (_ammoClass isEqualTo "") exitWith {
    _ctrlInfo ctrlSetStructuredText parseText localize "STR_MKK_PTG_EXPLOSION_AMMO_EMPTY";
};

private _cfg = configFile >> "CfgAmmo" >> _ammoClass;
if !(isClass _cfg) exitWith {
    _ctrlInfo ctrlSetStructuredText parseText localize "STR_MKK_PTG_INFO_NOT_FOUND";
};

private _hit = [_cfg, "hit", 0] call EFUNC(common,getSafeConfigNumber);
private _indirectHit = [_cfg, "indirectHit", 0] call EFUNC(common,getSafeConfigNumber);
private _indirectHitRange = [_cfg, "indirectHitRange", 0] call EFUNC(common,getSafeConfigNumber);
private _typicalSpeed = [_cfg, "typicalSpeed", 0] call EFUNC(common,getSafeConfigNumber);
private _submunitionAmmo = [_cfg, "submunitionAmmo", ""] call EFUNC(common,getSafeConfigText);
private _triggerDistance = [_cfg, "triggerDistance", 0] call EFUNC(common,getSafeConfigNumber);
private _categoryKey = [_cfg] call FUNC(getExplosionAmmoCategory);
private _category = if (_categoryKey isEqualTo "") then {localize "STR_MKK_PTG_UNKNOWN"} else {localize _categoryKey};
private _submunitionText = if (_submunitionAmmo isEqualTo "") then {
    localize "STR_MKK_PTG_NO"
} else {
    format ["%1: %2", localize "STR_MKK_PTG_YES", _submunitionAmmo]
};

private _text = format [
    "<t size='0.82'>%1<br/>%9: %2<br/>%10: %3<br/>%11: %4<br/>%12: %5<br/>%13: %6<br/>%14: %7<br/>%15: %8</t>",
    _ammoClass,
    _category,
    _hit,
    _indirectHit,
    _indirectHitRange,
    _typicalSpeed,
    _submunitionText,
    _triggerDistance,
    localize "STR_MKK_PTG_EXPLOSION_CATEGORY",
    localize "STR_MKK_PTG_HIT",
    localize "STR_MKK_PTG_INDIRECT_HIT",
    localize "STR_MKK_PTG_INDIRECT_HIT_RANGE",
    localize "STR_MKK_PTG_TYPICAL_SPEED",
    localize "STR_MKK_PTG_SUBMUNITION_AMMO",
    localize "STR_MKK_PTG_TRIGGER_DISTANCE"
];

_ctrlInfo ctrlSetStructuredText parseText _text;
