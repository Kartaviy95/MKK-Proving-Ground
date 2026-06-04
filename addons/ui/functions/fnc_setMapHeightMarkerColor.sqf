#include "..\script_component.hpp"
/*
    Stores the player-selected local map height marker color.
*/
if !(hasInterface) exitWith {};

params [
    ["_color", "ColorBlack", [""]]
];

private _allowedColors = [
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

if !(_color in _allowedColors) then {
    _color = "ColorBlack";
};

missionNamespace setVariable ["mkk_ptg_mapHeightMarkerColor", _color];
profileNamespace setVariable ["mkk_ptg_mapHeightMarkerColor", _color];
saveProfileNamespace;

private _markers = missionNamespace getVariable ["mkk_ptg_mapHeightMarkers", []];
{
    if ((_x find "mkk_ptg_map_height_") isEqualTo 0) then {
        _markers pushBackUnique _x;
    };
} forEach allMapMarkers;

private _activeMarkers = [];
{
    if ((markerType _x) isNotEqualTo "") then {
        _x setMarkerColorLocal _color;
        _activeMarkers pushBackUnique _x;
    };
} forEach _markers;
missionNamespace setVariable ["mkk_ptg_mapHeightMarkers", _activeMarkers];

_color
