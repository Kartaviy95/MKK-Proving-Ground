#include "..\script_component.hpp"
/*
    Requests a global smoke highlight at a map position selected by the local player.
*/
params [
    ["_position", [], [[]]]
];

if !(hasInterface) exitWith {false};
if ((count _position) < 2) exitWith {false};
if (isNil "ptg_spawn_fnc_requestPlaceMapSmoke") exitWith {false};

private _color = missionNamespace getVariable [
    "mkk_ptg_mapSmokeColor",
    profileNamespace getVariable ["mkk_ptg_mapSmokeColor", "ColorYellow"]
];

if !(_color in ["ColorWhite", "ColorRed", "ColorGreen", "ColorYellow", "ColorBlue", "ColorOrange", "ColorPink"]) then {
    _color = "ColorYellow";
};

private _mapPos = [_position # 0, _position # 1, 0];
[_mapPos, _color, player] call EFUNC(spawn,requestPlaceMapSmoke);

true
