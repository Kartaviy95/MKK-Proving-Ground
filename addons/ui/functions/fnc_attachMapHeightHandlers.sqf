#include "..\script_component.hpp"
/*
    Вешает локальные обработчики инструмента высоты на открытую карту.
*/
if !(hasInterface) exitWith {};
if !(missionNamespace getVariable ["mkk_ptg_mapHeightEnabled", false]) exitWith {};

private _display = findDisplay 12;
if (isNull _display) exitWith {};

private _handlers = missionNamespace getVariable ["mkk_ptg_mapHeightMapEHs", []];
private _attachedDisplay = if (_handlers isEqualTo []) then {displayNull} else {_handlers # 0};
if (_attachedDisplay isEqualTo _display) exitWith {};

[] call FUNC(detachMapHeightHandlers);
missionNamespace setVariable ["mkk_ptg_mapHeightHPressed", false];

private _keyDownEH = _display displayAddEventHandler ["KeyDown", {
    params ["_display", "_key", "_shift", "_ctrl", "_alt"];

    if !(missionNamespace getVariable ["mkk_ptg_mapHeightEnabled", false]) exitWith {false};
    if (_key isEqualTo DIK_DELETE) exitWith {
        if (_shift || {_ctrl} || {_alt}) exitWith {false};

        private _map = _display displayCtrl 51;
        if (isNull _map) exitWith {false};

        private _mouse = getMousePosition;
        private _markers = missionNamespace getVariable ["mkk_ptg_mapHeightMarkers", []];
        private _activeMarkers = [];
        {
            if ((markerType _x) isNotEqualTo "") then {
                _activeMarkers pushBackUnique _x;
            };
        } forEach _markers;
        {
            if ((_x find "mkk_ptg_map_height_") isEqualTo 0) then {
                _activeMarkers pushBackUnique _x;
            };
        } forEach allMapMarkers;
        _markers = _activeMarkers;
        missionNamespace setVariable ["mkk_ptg_mapHeightMarkers", _markers];

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

        deleteMarkerLocal _nearestMarker;
        private _markerIndex = _markers find _nearestMarker;
        if (_markerIndex >= 0) then {
            _markers deleteAt _markerIndex;
        };
        missionNamespace setVariable ["mkk_ptg_mapHeightMarkers", _markers];
        true
    };
    if (_key isNotEqualTo DIK_H) exitWith {false};
    if (missionNamespace getVariable ["mkk_ptg_mapHeightHPressed", false]) exitWith {true};
    missionNamespace setVariable ["mkk_ptg_mapHeightHPressed", true];
    if (_shift || {_ctrl} || {_alt}) exitWith {false};

    private _map = _display displayCtrl 51;
    if (isNull _map) exitWith {false};

    private _pos = _map ctrlMapScreenToWorld (getMousePosition);
    if ((count _pos) < 2) exitWith {true};

    private _x = _pos # 0;
    private _y = _pos # 1;
    private _heightASL = getTerrainHeightASL [_x, _y];
    private _heightText = _heightASL toFixed 0;
    private _markerText = format [localize "STR_MKK_PTG_MAP_HEIGHT_MARKER", _heightText];
    private _markerColor = missionNamespace getVariable ["mkk_ptg_mapHeightMarkerColor", "ColorBlack"];
    if !(_markerColor in ["ColorBlue", "ColorGreen", "ColorYellow", "ColorOrange", "ColorPink", "ColorRed", "ColorBrown", "ColorKhaki", "ColorBlack", "ColorGrey", "ColorWhite"]) then {
        _markerColor = "ColorBlack";
    };

    private _markerIndex = (missionNamespace getVariable ["mkk_ptg_mapHeightMarkerIndex", 0]) + 1;
    missionNamespace setVariable ["mkk_ptg_mapHeightMarkerIndex", _markerIndex];

    private _marker = format ["mkk_ptg_map_height_%1_%2", floor (diag_tickTime * 1000), _markerIndex];
    createMarkerLocal [_marker, [_x, _y, 0]];
    _marker setMarkerShapeLocal "ICON";
    _marker setMarkerTypeLocal "mil_triangle";
    _marker setMarkerColorLocal _markerColor;
    _marker setMarkerDirLocal 180;
    _marker setMarkerSizeLocal [0.5, 0.5];
    _marker setMarkerTextLocal _markerText;

    private _markers = missionNamespace getVariable ["mkk_ptg_mapHeightMarkers", []];
    _markers pushBackUnique _marker;
    missionNamespace setVariable ["mkk_ptg_mapHeightMarkers", _markers];

    true
}];

private _keyUpEH = _display displayAddEventHandler ["KeyUp", {
    params ["_display", "_key"];

    if (_key isEqualTo DIK_H) then {
        missionNamespace setVariable ["mkk_ptg_mapHeightHPressed", false];
    };

    false
}];

missionNamespace setVariable ["mkk_ptg_mapHeightMapEHs", [_display, _keyDownEH, _keyUpEH]];
