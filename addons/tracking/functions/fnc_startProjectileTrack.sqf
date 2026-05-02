#include "..\script_component.hpp"
/*
    Запускает локальную камеру слежения за projectile.
*/
params [
    ["_projectile", objNull],
    ["_ammoClass", ""],
    ["_weapon", ""]
];

if (isNull _projectile) exitWith {};
if !(hasInterface) exitWith {};

[] call FUNC(stopProjectileTrack);

private _camera = "camera" camCreate (getPosASL _projectile);
_camera cameraEffect ["Internal", "Back"];
showCinemaBorder false;
_camera attachTo [_projectile, [0, -3.5, 0.5]];

private _hudLayer = "mkk_ptg_trackingHudLayer" call BIS_fnc_rscLayer;
_hudLayer cutRsc ["MKK_PTG_TrackingHUD", "PLAIN", 0, false];

private _display = findDisplay 46;
if !(isNull _display) then {
    private _keyEH = _display displayAddEventHandler ["KeyDown", {
        params ["_display", "_key"];

        private _state = missionNamespace getVariable ["mkk_ptg_trackingState", createHashMap];
        if !(_state isEqualType createHashMap && {count _state > 0}) exitWith {false};

        if (_key isEqualTo DIK_ESCAPE) exitWith {
            [] call FUNC(stopProjectileTrack);
            true
        };

        false
    }];

    missionNamespace setVariable ["mkk_ptg_trackingKeyEH", _keyEH];
};

missionNamespace setVariable ["mkk_ptg_trackingState", createHashMapFromArray [
    ["camera", _camera],
    ["projectile", _projectile],
    ["ammoClass", _ammoClass],
    ["weapon", _weapon],
    ["startTime", diag_tickTime],
    ["startPos", getPosASL _projectile]
]];

missionNamespace setVariable ["mkk_ptg_trackingLastAt", diag_tickTime];

[_projectile] spawn FUNC(updateProjectileTrack);
