#include "..\script_component.hpp"
/*
    Places a global black marker at the requested explosion point.
*/
if !(hasInterface) exitWith {};

params [["_pos2D", [], [[]]]];

if ((count _pos2D) < 2) exitWith {};

private _markerIndex = (missionNamespace getVariable ["mkk_ptg_explosionMarkerIndex", 0]) + 1;
missionNamespace setVariable ["mkk_ptg_explosionMarkerIndex", _markerIndex];

private _marker = format ["mkk_ptg_explosion_marker_%1_%2_%3", clientOwner, floor (diag_tickTime * 1000), _markerIndex];
createMarker [_marker, [_pos2D # 0, _pos2D # 1, 0]];
_marker setMarkerShape "ICON";
_marker setMarkerType "mil_dot";
_marker setMarkerColor "ColorBlack";
_marker setMarkerSize [0.55, 0.55];
_marker setMarkerText localize "STR_MKK_PTG_EXPLOSION_MARKER";

private _markers = missionNamespace getVariable ["mkk_ptg_explosionMarkers", []];
_markers pushBackUnique _marker;
missionNamespace setVariable ["mkk_ptg_explosionMarkers", _markers];

_marker
