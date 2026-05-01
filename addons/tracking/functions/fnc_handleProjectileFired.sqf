#include "..\script_component.hpp"
/*
    Starts enabled local tracking features for a fired projectile.
*/
params [
    ["_projectile", objNull],
    ["_ammoClass", ""],
    ["_weapon", ""],
    ["_allowCamera", true],
    ["_allowAnalysis", true]
];

if !(hasInterface) exitWith {};
if (isNull _projectile) exitWith {};

if (_allowAnalysis) then {
    if (missionNamespace getVariable ["mkk_ptg_trajectoryEnabled", false]) then {
        [_projectile, _ammoClass] spawn FUNC(recordTrajectory);
    };

    if (missionNamespace getVariable ["mkk_ptg_mapProjectileMarkersEnabled", false]) then {
        [_projectile, _ammoClass] spawn FUNC(recordMapProjectileMarker);
    };
};

if (_allowCamera && {[_projectile, _ammoClass] call FUNC(canTrackProjectile)}) then {
    [_projectile, _ammoClass, _weapon] spawn FUNC(startProjectileTrack);
};
