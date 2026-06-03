#include "..\script_component.hpp"
/*
    Starts a local elapsed-time marker thread for the player's movement.
*/
if !(hasInterface) exitWith {};

params [
    ["_color", "ColorBlack", [""]]
];

private _validColors = [
    "ColorBlue",
    "ColorGreen",
    "ColorYellow",
    "ColorOrange",
    "ColorPink",
    "ColorRed",
    "ColorBrown",
    "ColorKhaki",
    "ColorBlack",
    "ColorGrey",
    "ColorWhite"
];
if (_color isEqualTo "" || {!(_color in _validColors)}) exitWith {[localize "STR_MKK_PTG_MAP_TIMING_INVALID_COLOR"] call EFUNC(main,showTimedHint)};

private _thread = missionNamespace getVariable ["mkk_ptg_mapTimingThread", scriptNull];
if !(scriptDone _thread) then {
    terminate _thread;
};

uiNamespace setVariable ["mkk_ptg_mainDisplayClosing", true];
uiNamespace setVariable ["mkk_ptg_webReady", false];
closeDialog 0;

missionNamespace setVariable ["mkk_ptg_mapTimingActive", true];
missionNamespace setVariable ["mkk_ptg_mapTimingColor", _color];
missionNamespace setVariable ["mkk_ptg_mapTimingStartTime", diag_tickTime];
missionNamespace setVariable ["mkk_ptg_mapTimingNextTime", diag_tickTime];
missionNamespace setVariable ["mkk_ptg_mapTimingLastPosition", position player];

_thread = [] spawn {
    while {missionNamespace getVariable ["mkk_ptg_mapTimingActive", false]} do {
        private _lastPos = missionNamespace getVariable ["mkk_ptg_mapTimingLastPosition", position player];
        private _currentPos = position player;
        private _distance = _lastPos distance _currentPos;
        private _nextTime = missionNamespace getVariable ["mkk_ptg_mapTimingNextTime", diag_tickTime];

        if (_distance > 10 && {(diag_tickTime >= _nextTime) || {_distance >= 300} || {visibleMap}}) then {
            [] call FUNC(renderMapTiming);
            missionNamespace setVariable ["mkk_ptg_mapTimingLastPosition", _currentPos];
            if (visibleMap) then {
                waitUntil {
                    uiSleep 0.1;
                    !(visibleMap) || {!(missionNamespace getVariable ["mkk_ptg_mapTimingActive", false])}
                };
            };
            missionNamespace setVariable ["mkk_ptg_mapTimingNextTime", diag_tickTime + 30];
        };

        uiSleep 0.1;
    };
};
missionNamespace setVariable ["mkk_ptg_mapTimingThread", _thread];

[localize "STR_MKK_PTG_MAP_TIMING_STARTED"] call EFUNC(main,showTimedHint);
