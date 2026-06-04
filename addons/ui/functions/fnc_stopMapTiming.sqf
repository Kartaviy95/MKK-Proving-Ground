#include "..\script_component.hpp"
/*
    Stops local timing and always places the final marker at the player position.
*/
if !(hasInterface) exitWith {};

private _thread = missionNamespace getVariable ["mkk_ptg_mapTimingThread", scriptNull];
if !(scriptDone _thread) then {
    terminate _thread;
};
missionNamespace setVariable ["mkk_ptg_mapTimingThread", scriptNull];

private _wasActive = missionNamespace getVariable ["mkk_ptg_mapTimingActive", false];
missionNamespace setVariable ["mkk_ptg_mapTimingActive", false];
[] call FUNC(hideMapTimingHud);

if !(_wasActive) exitWith {
    [localize "STR_MKK_PTG_MAP_TIMING_NOT_RUNNING"] call EFUNC(main,showTimedHint);
};

[] call FUNC(renderMapTiming);
missionNamespace setVariable ["mkk_ptg_mapTimingLastPosition", position player];

[localize "STR_MKK_PTG_MAP_TIMING_STOPPED"] call EFUNC(main,showTimedHint);
