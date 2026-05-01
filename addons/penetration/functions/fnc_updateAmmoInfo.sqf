#include "..\script_component.hpp"
/*
    Обновляет параметры выбранного боеприпаса.
*/
private _display = uiNamespace getVariable ["mkk_ptg_penetrationDisplay", displayNull];
if (isNull _display) exitWith {};

private _ctrlInfo = _display displayCtrl 88933;
private _ammoClass = missionNamespace getVariable ["mkk_ptg_penetrationAmmoClass", ""];
if (_ammoClass isEqualTo "") exitWith {
    _ctrlInfo ctrlSetStructuredText parseText localize "STR_MKK_PTG_AMMO_PARAMS_EMPTY";
};

private _cfg = configFile >> "CfgAmmo" >> _ammoClass;
if !(isClass _cfg) exitWith {
    _ctrlInfo ctrlSetStructuredText parseText localize "STR_MKK_PTG_INFO_NOT_FOUND";
};

private _caliber = [_cfg, "caliber", 0] call EFUNC(common,getSafeConfigNumber);
private _hit = [_cfg, "hit", 0] call EFUNC(common,getSafeConfigNumber);
private _indirectHit = [_cfg, "indirectHit", 0] call EFUNC(common,getSafeConfigNumber);
private _indirectHitRange = [_cfg, "indirectHitRange", 0] call EFUNC(common,getSafeConfigNumber);
private _airFriction = [_cfg, "airFriction", 0] call EFUNC(common,getSafeConfigNumber);
private _submunitionCfg = _cfg >> "submunitionAmmo";
private _submunitionAmmo = if (isText _submunitionCfg) then {getText _submunitionCfg} else {""};
private _submunitionText = if (_submunitionAmmo isEqualTo "") then {
    localize "STR_MKK_PTG_NO"
} else {
    format ["%1: %2", localize "STR_MKK_PTG_YES", _submunitionAmmo]
};

private _text = format [
    "<t size='0.82'>%1<br/>%8: %2<br/>%9: %3<br/>%10: %4<br/>%11: %5<br/>%12: %6<br/>%13: %7</t>",
    localize "STR_MKK_PTG_AMMO_PARAMS",
    _caliber,
    _hit,
    _indirectHit,
    _indirectHitRange,
    _airFriction,
    _submunitionText,
    localize "STR_MKK_PTG_CALIBER",
    localize "STR_MKK_PTG_HIT",
    localize "STR_MKK_PTG_INDIRECT_HIT",
    localize "STR_MKK_PTG_INDIRECT_HIT_RANGE",
    localize "STR_MKK_PTG_AIR_FRICTION",
    localize "STR_MKK_PTG_SUBMUNITION_AMMO"
];

_ctrlInfo ctrlSetStructuredText parseText _text;
