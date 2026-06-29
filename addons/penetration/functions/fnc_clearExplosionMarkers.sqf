#include "..\script_component.hpp"
/*
    Clears global explosion result markers created by the map explosion tool.
*/
if !(hasInterface) exitWith {};

params [["_silent", false, [false]]];

private _markers = missionNamespace getVariable ["mkk_ptg_explosionMarkers", []];
{
    if (_x isNotEqualTo "") then {
        deleteMarker _x;
    };
} forEach _markers;

{
    if ((_x find "mkk_ptg_explosion_marker_") isEqualTo 0) then {
        deleteMarker _x;
    };
} forEach allMapMarkers;

missionNamespace setVariable ["mkk_ptg_explosionMarkers", []];

if !(_silent) then {
    [localize "STR_MKK_PTG_EXPLOSION_MARKERS_CLEARED"] call EFUNC(main,showTimedHint);
};
