#include "..\script_component.hpp"
/*
    Регистрирует FiredMan EH у локального игрока.
*/
if !(hasInterface) exitWith {};
if (!alive player) exitWith {};

if (player getVariable ["mkk_ptg_trackingEHAdded", false]) exitWith {};

player addEventHandler ["FiredMan", {
    params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];

    if (missionNamespace getVariable ["mkk_ptg_trajectoryEnabled", false]) then {
        [_projectile, _ammo] spawn FUNC(recordTrajectory);
    };

    if (missionNamespace getVariable ["mkk_ptg_mapProjectileMarkersEnabled", false]) then {
        [_projectile, _ammo] spawn FUNC(recordMapProjectileMarker);
    };

    if !([_projectile, _ammo] call FUNC(canTrackProjectile)) exitWith {};
    [_projectile, _ammo, _weapon] spawn FUNC(startProjectileTrack);
}];

player setVariable ["mkk_ptg_trackingEHAdded", true];
