#include "..\script_component.hpp"
/*
    Stops local timing and clears local timing markers.
*/
if !(hasInterface) exitWith {};

params [["_silent", false, [false]]];

private _thread = missionNamespace getVariable ["mkk_ptg_mapTimingThread", scriptNull];
if !(scriptDone _thread) then {
    terminate _thread;
};

private _markers = missionNamespace getVariable ["mkk_ptg_mapTimingMarkers", []];
{
    if (_x isNotEqualTo "") then {
        deleteMarkerLocal _x;
    };
} forEach _markers;

missionNamespace setVariable ["mkk_ptg_mapTimingMarkers", []];
missionNamespace setVariable ["mkk_ptg_mapTimingActive", false];
missionNamespace setVariable ["mkk_ptg_mapTimingThread", scriptNull];
missionNamespace setVariable ["mkk_ptg_mapTimingLastPosition", position player];

if !(_silent) then {
    [localize "STR_MKK_PTG_MAP_TIMING_CLEARED"] call EFUNC(main,showTimedHint);
};
