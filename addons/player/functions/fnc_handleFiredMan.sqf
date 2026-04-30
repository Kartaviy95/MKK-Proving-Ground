#include "..\script_component.hpp"
/*
    Восстанавливает патроны после выстрела локального игрока.
*/
params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine"];

if (!hasInterface || {_unit isNotEqualTo player}) exitWith {};
if !(missionNamespace getVariable ["mkk_ptg_infiniteAmmoEnabled", false]) exitWith {};
if (_weapon isEqualTo "" || {_magazine isEqualTo ""}) exitWith {};

private _maxAmmo = getNumber (configFile >> "CfgMagazines" >> _magazine >> "count");
if (_maxAmmo <= 0) exitWith {};

[
    {
        params ["_unit", "_weapon", "_muzzle", "_magazine", "_maxAmmo"];

        if (isNull _unit || {!alive _unit} || {_unit isNotEqualTo player}) exitWith {};
        if !(missionNamespace getVariable ["mkk_ptg_infiniteAmmoEnabled", false]) exitWith {};

        private _weaponToRefill = _weapon;
        if !(_muzzle in ["", _weapon]) then {
            _weaponToRefill = _muzzle;
        };

        _unit setAmmo [_weaponToRefill, _maxAmmo];

        if !(_magazine in magazines _unit) then {
            _unit addMagazine _magazine;
        };
    },
    [_unit, _weapon, _muzzle, _magazine, _maxAmmo]
] call CBA_fnc_execNextFrame;
