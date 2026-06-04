#include "..\script_component.hpp"
/*
    Global smoke highlight creation. Can run on a client: createVehicle and
    createMarker synchronize in MP.
*/
params [
    ["_position", [], [[]]],
    ["_color", "ColorYellow", [""]],
    ["_requestor", objNull, [objNull]]
];

if ((count _position) < 2) exitWith {false};
if (isNull _requestor) exitWith {false};

private _smokeData = switch (_color) do {
    case "ColorWhite": {["SmokeShell", "ColorWhite"]};
    case "ColorRed": {["SmokeShellRed", "ColorRed"]};
    case "ColorGreen": {["SmokeShellGreen", "ColorGreen"]};
    case "ColorYellow": {["SmokeShellYellow", "ColorYellow"]};
    case "ColorBlue": {["SmokeShellBlue", "ColorBlue"]};
    case "ColorOrange": {["SmokeShellOrange", "ColorOrange"]};
    case "ColorPink": {["SmokeShellPurple", "ColorPink"]};
    default {["SmokeShellYellow", "ColorYellow"]};
};

private _smokeClass = _smokeData # 0;
private _markerColor = _smokeData # 1;
if !(isClass (configFile >> "CfgAmmo" >> _smokeClass)) then {
    _smokeClass = "SmokeShellYellow";
    _markerColor = "ColorYellow";
};

private _mapPos = [_position # 0, _position # 1, 0];
private _markerIndex = (missionNamespace getVariable ["mkk_ptg_mapSmokeMarkerIndex", 0]) + 1;
missionNamespace setVariable ["mkk_ptg_mapSmokeMarkerIndex", _markerIndex];

private _uid = getPlayerUID _requestor;
if (_uid isEqualTo "") then {
    _uid = "local";
};

private _markerName = format ["mkk_ptg_map_smoke_%1_%2_%3", _uid, floor (diag_tickTime * 1000), _markerIndex];
private _marker = createMarker [_markerName, _mapPos];
_marker setMarkerShape "ICON";
_marker setMarkerType "mil_dot";
_marker setMarkerColor _markerColor;
_marker setMarkerSize [1.5, 1.5];
_marker setMarkerText (name _requestor);

createVehicle [_smokeClass, _mapPos, [], 0, "FLY"];

private _markers = missionNamespace getVariable ["mkk_ptg_mapSmokeMarkers", []];
_markers pushBack _marker;
while {(count _markers) > 40} do {
    deleteMarker (_markers deleteAt 0);
};
missionNamespace setVariable ["mkk_ptg_mapSmokeMarkers", _markers];

[_marker] spawn {
    params ["_marker"];

    sleep 3;
    deleteMarker _marker;

    private _markers = missionNamespace getVariable ["mkk_ptg_mapSmokeMarkers", []];
    private _markerIndex = _markers find _marker;
    if (_markerIndex >= 0) then {
        _markers deleteAt _markerIndex;
        missionNamespace setVariable ["mkk_ptg_mapSmokeMarkers", _markers];
    };
};

true
