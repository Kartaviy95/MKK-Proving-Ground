#include "..\script_component.hpp"
/*
    Stores the player-selected map smoke color.
*/
params [
    ["_color", "ColorYellow", [""]]
];

private _allowedColors = [
    "ColorWhite",
    "ColorRed",
    "ColorGreen",
    "ColorYellow",
    "ColorBlue",
    "ColorOrange",
    "ColorPink"
];

if !(_color in _allowedColors) then {
    _color = "ColorYellow";
};

missionNamespace setVariable ["mkk_ptg_mapSmokeColor", _color];
profileNamespace setVariable ["mkk_ptg_mapSmokeColor", _color];
saveProfileNamespace;

_color
