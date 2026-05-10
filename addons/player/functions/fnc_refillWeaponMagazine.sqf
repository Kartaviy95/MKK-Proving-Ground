#include "..\script_component.hpp"
/*
    Восстанавливает магазин оружия с учетом launcher-слота.
*/
params [
    ["_unit", objNull, [objNull]],
    ["_weapon", "", [""]],
    ["_muzzle", "", [""]],
    ["_magazine", "", [""]],
    ["_maxAmmo", 0, [0]]
];

if (isNull _unit || {_weapon isEqualTo ""} || {_magazine isEqualTo ""} || {_maxAmmo <= 0}) exitWith {};

private _weaponCfg = configFile >> "CfgWeapons" >> _weapon;
private _weaponType = getNumber (_weaponCfg >> "type");
private _weaponToRefill = _weapon;
if !(_muzzle in ["", _weapon]) then {
    _weaponToRefill = _muzzle;
};

if (_weaponType isEqualTo 4) then {
    private _currentSecondary = secondaryWeapon _unit;
    if (_currentSecondary isNotEqualTo _weapon) then {
        if (_currentSecondary isNotEqualTo "") then {
            _unit removeWeapon _currentSecondary;
        };
        _unit addWeapon _weapon;
    };

    _unit addWeaponItem [_weapon, [_magazine, _maxAmmo, _weaponToRefill], true];
    if ((_unit ammo _weaponToRefill) <= 0) then {
        _unit addSecondaryWeaponItem _magazine;
    };
} else {
    if !(_magazine in magazines _unit) then {
        _unit addMagazine _magazine;
    };
};

_unit setAmmo [_weaponToRefill, _maxAmmo];
