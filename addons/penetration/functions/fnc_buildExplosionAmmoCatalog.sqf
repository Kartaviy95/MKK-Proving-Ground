#include "..\script_component.hpp"
/*
    Builds cached grouped CfgAmmo list for the explosion tool.
*/
private _cached = missionNamespace getVariable ["mkk_ptg_explosionAmmoCatalog", []];
if (_cached isNotEqualTo []) exitWith {_cached};

private _items = [];

{
    private _cfg = _x;
    private _className = configName _cfg;
    private _classNameLower = toLowerANSI _className;
    private _simulation = toLowerANSI ([_cfg, "simulation", ""] call EFUNC(common,getSafeConfigText));
    private _hit = [_cfg, "hit", 0] call EFUNC(common,getSafeConfigNumber);
    private _indirectHit = [_cfg, "indirectHit", 0] call EFUNC(common,getSafeConfigNumber);

    if !(_simulation in ["shotbomb", "shotshell", "shotrocket", "shotmissile"]) then {continue};
    if ("base" in _classNameLower) then {continue};
    if ((_hit + _indirectHit) <= 0) then {continue};

    private _categoryKey = [_cfg] call FUNC(getExplosionAmmoCategory);
    if (_categoryKey isEqualTo "") then {continue};

    private _displayName = [_cfg, "displayName", _className] call EFUNC(common,getSafeConfigText);
    _displayName = [_displayName] call EFUNC(common,localizeString);
    if (_displayName isEqualTo "") then {_displayName = _className;};

    _items pushBack [_categoryKey, _displayName, _className];
} forEach ("true" configClasses (configFile >> "CfgAmmo"));

_items sort true;
missionNamespace setVariable ["mkk_ptg_explosionAmmoCatalog", _items];
_items
