#include "..\script_component.hpp"
/*
    Помечает локального игрока как использующего бесконечные патроны.
    При включении сразу восстанавливает БК, в том числе если магазин уже был
    отстрелян в ноль и FiredMan больше не может сработать.
*/
params [
    ["_unit", player, [objNull]],
    ["_enabled", missionNamespace getVariable ["mkk_ptg_infiniteAmmoEnabled", false], [false]]
];

if (!hasInterface || {isNull _unit}) exitWith {};

_unit setVariable ["mkk_ptg_infiniteAmmoUnitEnabled", _enabled];

if (!_enabled) exitWith {};

[
    {
        params ["_unit"];

        if (isNull _unit || {!alive _unit} || {_unit isNotEqualTo player}) exitWith {};
        if !(missionNamespace getVariable ["mkk_ptg_infiniteAmmoEnabled", false]) exitWith {};

        private _vehicle = vehicle _unit;
        if (_vehicle isNotEqualTo _unit) then {
            _vehicle setVehicleAmmo 1;
        };

        private _fnc_getFallbackMagazine = {
            params ["_weapon"];

            private _magazine = _unit getVariable [format ["mkk_ptg_infiniteAmmoLastMagazine_%1", _weapon], ""];
            if (_magazine isNotEqualTo "") exitWith {_magazine};

            private _weaponConfig = configFile >> "CfgWeapons" >> _weapon;
            private _magazines = getArray (_weaponConfig >> "magazines");
            if (_magazines isNotEqualTo []) exitWith {_magazines # 0};

            private _muzzles = getArray (_weaponConfig >> "muzzles");
            {
                private _muzzle = _x;
                private _muzzleConfig = _weaponConfig;
                if (_muzzle isNotEqualTo "this") then {
                    _muzzleConfig = _weaponConfig >> _muzzle;
                };

                _magazines = getArray (_muzzleConfig >> "magazines");
                if (_magazines isNotEqualTo []) exitWith {_magazines # 0};
            } forEach _muzzles;
        };

        private _fnc_refillWeapon = {
            params ["_weapon"];

            if (_weapon isEqualTo "") exitWith {};

            private _magazine = _weapon call _fnc_getFallbackMagazine;
            if (isNil "_magazine" || {_magazine isEqualTo ""}) exitWith {};

            private _maxAmmo = getNumber (configFile >> "CfgMagazines" >> _magazine >> "count");
            if (_maxAmmo <= 0) exitWith {};

            [_unit, _weapon, _weapon, _magazine, _maxAmmo] call FUNC(refillWeaponMagazine);
        };

        {
            _x call _fnc_refillWeapon;
        } forEach ([currentWeapon _unit, primaryWeapon _unit, handgunWeapon _unit, secondaryWeapon _unit] arrayIntersect [currentWeapon _unit, primaryWeapon _unit, handgunWeapon _unit, secondaryWeapon _unit]);
    },
    [_unit]
] call CBA_fnc_execNextFrame;
