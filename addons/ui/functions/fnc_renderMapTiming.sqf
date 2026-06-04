#include "..\script_component.hpp"
/*
    Places one local timing marker at the player's current position.
    This mirrors the old SGT timing flow: elapsed time is measured from the
    start command and no route, roads, slope or pathfinding are used.
*/
if !(hasInterface) exitWith {};

private _color = missionNamespace getVariable ["mkk_ptg_mapTimingColor", "ColorBlack"];
if !(_color in ["ColorBlue", "ColorGreen", "ColorYellow", "ColorOrange", "ColorPink", "ColorRed", "ColorBrown", "ColorKhaki", "ColorBlack", "ColorGrey", "ColorWhite"]) then {
    _color = "ColorBlack";
};
private _startTime = missionNamespace getVariable ["mkk_ptg_mapTimingStartTime", diag_tickTime];
private _elapsed = floor (diag_tickTime - _startTime);
private _text = [_elapsed] call FUNC(formatTimingTime);
if (missionNamespace getVariable ["mkk_ptg_mapTimingShowSpeed", false]) then {
    private _speed = round (abs (speed (vehicle player)));
    _text = format [localize "STR_MKK_PTG_MAP_TIMING_MARKER_WITH_SPEED", _text, _speed];
};
private _markerIndex = (missionNamespace getVariable ["mkk_ptg_mapTimingMarkerIndex", 0]) + 1;
missionNamespace setVariable ["mkk_ptg_mapTimingMarkerIndex", _markerIndex];

private _marker = format ["mkk_ptg_timing_%1_%2", floor (diag_tickTime * 1000), _markerIndex];
createMarkerLocal [_marker, position player];
_marker setMarkerShapeLocal "ICON";
_marker setMarkerTypeLocal "mil_triangle";
_marker setMarkerColorLocal _color;
_marker setMarkerSizeLocal [0.5, 0.5];
_marker setMarkerTextLocal _text;

missionNamespace setVariable ["mkk_ptg_mapTimingMarkers", (missionNamespace getVariable ["mkk_ptg_mapTimingMarkers", []]) + [_marker]];
