#include "..\script_component.hpp"
/*
    Регистрирует локальные fired handlers для игрока и техники/статики, которой он управляет.
*/
if !(hasInterface) exitWith {};
if (isNull player || {!alive player}) exitWith {};

if !(player getVariable ["mkk_ptg_trackingEHAdded", false]) then {
    player addEventHandler ["FiredMan", {
        params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];

        if (_unit isNotEqualTo player) exitWith {};
        [_projectile, _ammo, _weapon, true, true] call FUNC(handleProjectileFired);
    }];

    player setVariable ["mkk_ptg_trackingEHAdded", true];
};

private _vehicle = vehicle player;
if (_vehicle isEqualTo player) exitWith {};
if (_vehicle getVariable ["mkk_ptg_trackingFiredEHAdded", false]) exitWith {};

_vehicle addEventHandler ["Fired", {
    params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", ["_gunner", objNull]];

    if (_unit isNotEqualTo vehicle player) exitWith {};
    if (!isNull _gunner && {_gunner isNotEqualTo player}) exitWith {};
    [_projectile, _ammo, _weapon, true, true] call FUNC(handleProjectileFired);
}];

_vehicle setVariable ["mkk_ptg_trackingFiredEHAdded", true];
