#include "..\script_component.hpp"
/*
    Returns localized category key for ammo suitable for map explosion creation.
*/
params [
    ["_cfg", configNull]
];

if (isNull _cfg) exitWith {""};

private _className = configName _cfg;
private _displayName = [_cfg, "displayName", _className] call EFUNC(common,getSafeConfigText);
_displayName = [_displayName] call EFUNC(common,localizeString);
private _simulation = toLowerANSI ([_cfg, "simulation", ""] call EFUNC(common,getSafeConfigText));
private _artilleryLock = [_cfg, "artilleryLock", 0] call EFUNC(common,getSafeConfigNumber);

private _parents = [];
private _parent = inheritsFrom _cfg;
while {!(isNull _parent)} do {
    _parents pushBackUnique (toLowerANSI configName _parent);
    _parent = inheritsFrom _parent;
};

private _haystack = toLowerANSI format ["%1 %2 %3", _className, _displayName, _parents joinString " "];

if (_simulation isEqualTo "shotbomb" || {"bomb" in _haystack}) exitWith {
    "STR_MKK_PTG_EXPLOSION_GROUP_BOMBS"
};
if (_artilleryLock > 0 || {"mortar" in _haystack}) exitWith {
    "STR_MKK_PTG_EXPLOSION_GROUP_MORTARS"
};
if (_simulation isEqualTo "shotmissile") exitWith {
    "STR_MKK_PTG_EXPLOSION_GROUP_ATGM"
};
if (_simulation isEqualTo "shotrocket" || {"rocket" in _haystack}) exitWith {
    "STR_MKK_PTG_EXPLOSION_GROUP_ROCKETS"
};

""
