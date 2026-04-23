/*
    Регистрирует FiredMan EH у локального игрока.
*/
if !(hasInterface) exitWith {};
if (!alive player) exitWith {};

if (player getVariable ["mkk_ptg_trackingEHAdded", false]) exitWith {};

player addEventHandler ["FiredMan", {
    params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];

    if !([_projectile, _ammo] call mkk_ptg_fnc_canTrackProjectile) exitWith {};
    [_projectile, _ammo, _weapon] spawn mkk_ptg_fnc_startProjectileTrack;
}];

player setVariable ["mkk_ptg_trackingEHAdded", true];
