#include "..\script_component.hpp"
/*
    Закрывает активную локальную камеру полигона.
*/
if (missionNamespace getVariable ["mkk_ptg_mapCameraRunning", false]) exitWith {
    [] call ptg_ui_fnc_stopMapCamera;
    true
};

private _trackingState = missionNamespace getVariable ["mkk_ptg_trackingState", createHashMap];
if (_trackingState isEqualType createHashMap && {count _trackingState > 0} && {!isNil "ptg_tracking_fnc_stopProjectileTrack"}) exitWith {
    [] call ptg_tracking_fnc_stopProjectileTrack;
    true
};

false
