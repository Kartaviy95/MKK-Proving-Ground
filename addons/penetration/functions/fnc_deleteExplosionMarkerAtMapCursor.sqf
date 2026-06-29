#include "..\script_component.hpp"
/*
    Deletes the nearest global explosion marker under the current map cursor.
*/
if !(hasInterface) exitWith {false};

params [
    ["_display", displayNull, [displayNull]],
    ["_map", controlNull, [controlNull]],
    ["_showHint", true, [false]]
];

if (isNull _display || {isNull _map}) exitWith {false};

private _mouse = getMousePosition;
private _mapPos = ctrlPosition _map;
if (
    (_mouse # 0) < (_mapPos # 0)
    || {(_mouse # 0) > ((_mapPos # 0) + (_mapPos # 2))}
    || {(_mouse # 1) < (_mapPos # 1)}
    || {(_mouse # 1) > ((_mapPos # 1) + (_mapPos # 3))}
) exitWith {false};

private _markers = missionNamespace getVariable ["mkk_ptg_explosionMarkers", []];
private _activeMarkers = [];
{
    if (_x isNotEqualTo "" && {(markerType _x) isNotEqualTo ""}) then {
        _activeMarkers pushBackUnique _x;
    };
} forEach _markers;
{
    if ((_x find "mkk_ptg_explosion_marker_") isEqualTo 0) then {
        _activeMarkers pushBackUnique _x;
    };
} forEach allMapMarkers;
_markers = _activeMarkers;
missionNamespace setVariable ["mkk_ptg_explosionMarkers", _markers];

private _nearestMarker = "";
private _nearestDistance = 999;
{
    private _screenPos = _map ctrlMapWorldToScreen (markerPos _x);
    if ((count _screenPos) >= 2) then {
        private _dx = (_screenPos # 0) - (_mouse # 0);
        private _dy = (_screenPos # 1) - (_mouse # 1);
        private _distance = sqrt ((_dx * _dx) + (_dy * _dy));

        if (_distance < _nearestDistance) then {
            _nearestMarker = _x;
            _nearestDistance = _distance;
        };
    };
} forEach _markers;

if (_nearestDistance > 0.045) exitWith {false};

deleteMarker _nearestMarker;
private _markerIndex = _markers find _nearestMarker;
if (_markerIndex >= 0) then {
    _markers deleteAt _markerIndex;
};
missionNamespace setVariable ["mkk_ptg_explosionMarkers", _markers];

if (_showHint) then {
    [localize "STR_MKK_PTG_EXPLOSION_MARKER_DELETED"] call EFUNC(main,showTimedHint);
};

true
