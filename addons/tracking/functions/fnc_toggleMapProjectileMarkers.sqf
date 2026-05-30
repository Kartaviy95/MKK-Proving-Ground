#include "..\script_component.hpp"
/*
    Переключает маркеры projectile на карте.
*/
private _enabled = !(missionNamespace getVariable ["mkk_ptg_mapProjectileMarkersEnabled", false]);
missionNamespace setVariable ["mkk_ptg_mapProjectileMarkersEnabled", _enabled];

if (_enabled) then {
    [] call FUNC(registerTrackingEH);
} else {
    private _markers = missionNamespace getVariable ["mkk_ptg_mapProjectileMarkers", []];
    {
        deleteMarkerLocal _x;
    } forEach _markers;
    missionNamespace setVariable ["mkk_ptg_mapProjectileMarkers", []];
};
