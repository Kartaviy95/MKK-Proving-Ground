#include "..\script_component.hpp"
/*
    Stores player-selected settings for local map timing markers.
*/
if !(hasInterface) exitWith {};

params [
    ["_key", "", [""]],
    ["_value", "", [""]]
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

switch (_key) do {
    case "color": {
        if !(_value in _allowedColors) then {
            _value = "ColorBlack";
        };

        missionNamespace setVariable ["mkk_ptg_mapTimingColor", _value];
        profileNamespace setVariable ["mkk_ptg_mapTimingColor", _value];
    };
    case "interval": {
        private _interval = round parseNumber _value;
        if !(_interval in [5, 10, 15, 20, 30, 60]) then {
            _interval = 10;
        };

        missionNamespace setVariable ["mkk_ptg_mapTimingInterval", _interval];
        profileNamespace setVariable ["mkk_ptg_mapTimingInterval", _interval];
    };
    case "showSpeed": {
        private _enabled = !(missionNamespace getVariable ["mkk_ptg_mapTimingShowSpeed", false]);
        missionNamespace setVariable ["mkk_ptg_mapTimingShowSpeed", _enabled];
        profileNamespace setVariable ["mkk_ptg_mapTimingShowSpeed", _enabled];
    };
};

saveProfileNamespace;
[] call FUNC(drawMapTimingHud);
