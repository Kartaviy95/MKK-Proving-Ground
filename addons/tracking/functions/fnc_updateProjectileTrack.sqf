#include "..\script_component.hpp"
/*
    Ведет projectile до таймаута или уничтожения.
*/
params [
    ["_projectile", objNull]
];

if (isNull _projectile) exitWith {};

private _maxTime = missionNamespace getVariable ["mkk_ptg_trackingMaxTime", 8];
private _startedAt = diag_tickTime;

while {true} do {
    if (isNull _projectile) exitWith {};
    if ((diag_tickTime - _startedAt) > _maxTime) exitWith {};

    [] call FUNC(drawTrackingHud);
    uiSleep 0.02;
};

[] call FUNC(stopProjectileTrack);
