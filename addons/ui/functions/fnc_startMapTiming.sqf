#include "..\script_component.hpp"
/*
    Starts a local elapsed-time marker thread for the player's movement.
*/
if !(hasInterface) exitWith {};

params [
    ["_color", "", [""]]
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
private _useStoredColor = _color isEqualTo "";
if (_useStoredColor) then {
    _color = missionNamespace getVariable ["mkk_ptg_mapTimingColor", profileNamespace getVariable ["mkk_ptg_mapTimingColor", "ColorBlack"]];
};
if !(_color in _validColors) then {
    if !(_useStoredColor) exitWith {[localize "STR_MKK_PTG_MAP_TIMING_INVALID_COLOR"] call EFUNC(main,showTimedHint)};
    _color = "ColorBlack";
};

private _interval = missionNamespace getVariable ["mkk_ptg_mapTimingInterval", profileNamespace getVariable ["mkk_ptg_mapTimingInterval", 10]];
if !(_interval isEqualType 0) then {
    _interval = 10;
};
_interval = round _interval;
if !(_interval in [5, 10, 15, 20, 30, 60]) then {
    _interval = 10;
};

private _thread = missionNamespace getVariable ["mkk_ptg_mapTimingThread", scriptNull];
if !(scriptDone _thread) then {
    terminate _thread;
};

uiNamespace setVariable ["mkk_ptg_mainDisplayClosing", true];
uiNamespace setVariable ["mkk_ptg_webReady", false];
closeDialog 0;

private _startTime = diag_tickTime;
missionNamespace setVariable ["mkk_ptg_mapTimingActive", true];
missionNamespace setVariable ["mkk_ptg_mapTimingColor", _color];
profileNamespace setVariable ["mkk_ptg_mapTimingColor", _color];
saveProfileNamespace;
missionNamespace setVariable ["mkk_ptg_mapTimingStartTime", _startTime];
missionNamespace setVariable ["mkk_ptg_mapTimingNextTime", _startTime + _interval];
missionNamespace setVariable ["mkk_ptg_mapTimingLastPosition", position player];

[] call FUNC(renderMapTiming);
[] call FUNC(drawMapTimingHud);

_thread = [] spawn {
    while {missionNamespace getVariable ["mkk_ptg_mapTimingActive", false]} do {
        [] call FUNC(drawMapTimingHud);

        private _lastPos = missionNamespace getVariable ["mkk_ptg_mapTimingLastPosition", position player];
        private _currentPos = position player;
        private _distance = _lastPos distance _currentPos;
        private _nextTime = missionNamespace getVariable ["mkk_ptg_mapTimingNextTime", diag_tickTime];
        private _interval = missionNamespace getVariable ["mkk_ptg_mapTimingInterval", 10];
        if !(_interval isEqualType 0) then {
            _interval = 10;
        };
        _interval = round _interval;
        if !(_interval in [5, 10, 15, 20, 30, 60]) then {
            _interval = 10;
        };

        if (_distance > 10 && {(diag_tickTime >= _nextTime) || {_distance >= 300} || {visibleMap}}) then {
            [] call FUNC(renderMapTiming);
            missionNamespace setVariable ["mkk_ptg_mapTimingLastPosition", _currentPos];
            if (visibleMap) then {
                waitUntil {
                    uiSleep 0.1;
                    !(visibleMap) || {!(missionNamespace getVariable ["mkk_ptg_mapTimingActive", false])}
                };
            };
            missionNamespace setVariable ["mkk_ptg_mapTimingNextTime", diag_tickTime + _interval];
        };

        uiSleep 0.1;
    };
};
missionNamespace setVariable ["mkk_ptg_mapTimingThread", _thread];

[localize "STR_MKK_PTG_MAP_TIMING_STARTED"] call EFUNC(main,showTimedHint);
