#include "..\script_component.hpp"
/*
    Восстанавливает патроны после выстрела локального игрока.
*/
params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine"];

if (!hasInterface || {_unit isNotEqualTo player}) exitWith {};
if (_weapon isEqualTo "" || {_magazine isEqualTo ""}) exitWith {};

_unit setVariable [format ["mkk_ptg_infiniteAmmoLastMagazine_%1", _weapon], _magazine];
if !(_muzzle in ["", _weapon]) then {
    _unit setVariable [format ["mkk_ptg_infiniteAmmoLastMagazine_%1", _muzzle], _magazine];
};

if !(missionNamespace getVariable ["mkk_ptg_infiniteAmmoEnabled", false]) exitWith {};

private _maxAmmo = getNumber (configFile >> "CfgMagazines" >> _magazine >> "count");
if (_maxAmmo <= 0) exitWith {};

[
    {
        params ["_unit", "_weapon", "_muzzle", "_magazine", "_maxAmmo"];

        if (isNull _unit || {!alive _unit} || {_unit isNotEqualTo player}) exitWith {};
        if !(missionNamespace getVariable ["mkk_ptg_infiniteAmmoEnabled", false]) exitWith {};

        private _vehicle = vehicle _unit;
        if (_vehicle isNotEqualTo _unit) then {
            _vehicle setVehicleAmmo 1;
        };

        [_unit, _weapon, _muzzle, _magazine, _maxAmmo] call FUNC(refillWeaponMagazine);
    },
    [_unit, _weapon, _muzzle, _magazine, _maxAmmo]
] call CBA_fnc_execNextFrame;
