#include "..\script_component.hpp"
/*
    Возвращает ammo boxes, в которых есть магазины для выбранной статики.
*/
params [
    ["_className", ""]
];

if (_className isEqualTo "") exitWith {[]};
if !(_className isKindOf "StaticWeapon") exitWith {[]};

private _cache = missionNamespace getVariable ["mkk_ptg_staticAmmoBoxCache", createHashMap];
private _cached = _cache getOrDefault [_className, false];
if (_cached isEqualType []) exitWith {_cached};

private _cfg = configFile >> "CfgVehicles" >> _className;
if !(isClass _cfg) exitWith {[]};

private _weapons = [];
private _magazines = [];

private _collectWeaponNode = {
    params ["_node"];

    {
        if (_x isNotEqualTo "") then {
            _weapons pushBackUnique _x;
        };
    } forEach getArray (_node >> "weapons");

    {
        if (_x isNotEqualTo "") then {
            _magazines pushBackUnique _x;
        };
    } forEach getArray (_node >> "magazines");

    {
        [_x] call _collectWeaponNode;
    } forEach ("true" configClasses (_node >> "Turrets"));
};

[_cfg] call _collectWeaponNode;

{
    private _weaponCfg = configFile >> "CfgWeapons" >> _x;
    if (isClass _weaponCfg) then {
        {
            if (_x isNotEqualTo "") then {
                _magazines pushBackUnique _x;
            };
        } forEach getArray (_weaponCfg >> "magazines");
    };
} forEach _weapons;

if (_magazines isEqualTo []) exitWith {
    _cache set [_className, []];
    missionNamespace setVariable ["mkk_ptg_staticAmmoBoxCache", _cache];
    []
};

private _boxes = [];
private _cfgVehicles = configFile >> "CfgVehicles";

{
    private _boxCfg = _x;
    private _boxClass = configName _boxCfg;

    if !(isClass _boxCfg) then {continue};
    if (getNumber (_boxCfg >> "scope") < 2) then {continue};
    if !(_boxClass isKindOf "ReammoBox_F" || {_boxClass isKindOf "ReammoBox"}) then {continue};

    private _matches = [];

    {
        private _magazine = [_x, "magazine", ""] call EFUNC(common,getSafeConfigText);
        if (_magazine in _magazines) then {
            _matches pushBackUnique _magazine;
        };
    } forEach ("true" configClasses (_boxCfg >> "TransportMagazines"));

    if (_matches isEqualTo []) then {continue};

    private _displayName = [_boxCfg, "displayName", _boxClass] call EFUNC(common,getSafeConfigText);
    _displayName = [_displayName] call EFUNC(common,localizeString);
    if (_displayName isEqualTo "") then {
        _displayName = _boxClass;
    };

    private _source = [_boxCfg] call EFUNC(common,getModSource);
    _boxes pushBack [_boxClass, _displayName, _source, _matches];
} forEach ("true" configClasses _cfgVehicles);

_boxes sort true;

_cache set [_className, _boxes];
missionNamespace setVariable ["mkk_ptg_staticAmmoBoxCache", _cache];

_boxes
