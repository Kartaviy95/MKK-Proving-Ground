#include "..\script_component.hpp"
/*
    Starts a simple free camera.
    Controls: W/S/A/D move, Q up, Z down, mouse look, mouse wheel speed, Shift faster.
    F1 toggles the control overlay. Close key is configured through CBA keybinds.
*/
if !(hasInterface) exitWith {};

closeDialog 0;
[] call FUNC(stopMapCamera);

private _startPos = getPosATLVisual player;
private _camera = "camera" camCreate [_startPos # 0, _startPos # 1, ((_startPos # 2) max 0) + 20];
_camera cameraEffect ["Internal", "Back"];
showCinemaBorder false;

private _dir = getDirVisual player;
_camera setDir _dir;
[_camera, -20, 0] call BIS_fnc_setPitchBank;
_camera camCommit 0;

missionNamespace setVariable ["mkk_ptg_mapCameraState", createHashMapFromArray [
    ["camera", _camera],
    ["dir", _dir],
    ["pitch", -20],
    ["speed", 45],
    ["keys", []]
]];
missionNamespace setVariable ["mkk_ptg_mapCameraRunning", true];

missionNamespace setVariable ["mkk_ptg_mapCameraHintVisible", true];

private _hintDisplay = findDisplay 46;
if !(isNull _hintDisplay) then {
    private _bg = _hintDisplay ctrlCreate ["RscText", -1];
    _bg ctrlSetPosition [safeZoneX + safeZoneW - 0.36, safeZoneY + 0.12, 0.34, 0.45];
    _bg ctrlSetBackgroundColor [0, 0, 0, 0.68];
    _bg ctrlCommit 0;

    private _text = _hintDisplay ctrlCreate ["RscStructuredText", -1];
    _text ctrlSetPosition [safeZoneX + safeZoneW - 0.35, safeZoneY + 0.13, 0.32, 0.45];
    _text ctrlSetStructuredText parseText format [
        "<t align='center' size='1.18' font='RobotoCondensedBold' color='#F2F2F2'>%1</t><br/>" +
        "<t size='0.95' color='#FFFFFF'>W / S</t><t size='0.95' color='#CFCFCF'>    %2</t><br/>" +
        "<t size='0.95' color='#FFFFFF'>A / D</t><t size='0.95' color='#CFCFCF'>    %3</t><br/>" +
        "<t size='0.95' color='#FFFFFF'>Q</t><t size='0.95' color='#CFCFCF'>        %4</t><br/>" +
        "<t size='0.95' color='#FFFFFF'>Z</t><t size='0.95' color='#CFCFCF'>        %5</t><br/>" +
        "<t size='0.95' color='#FFFFFF'>Shift</t><t size='0.95' color='#CFCFCF'>    %6</t><br/>" +
        "<t size='0.95' color='#FFFFFF'>%7</t><t size='0.95' color='#CFCFCF'>    %8</t><br/>" +
        "<t size='0.95' color='#FFFFFF'>%9</t><t size='0.95' color='#CFCFCF'>   %10</t><br/>" +
        "<t size='0.95' color='#FFFFFF'>F1</t><t size='0.95' color='#CFCFCF'>       %11</t><br/>" +
        "<t align='center' size='0.86' color='#DADADA'>%12</t>",
        localize "STR_MKK_PTG_CAMERA_CONTROLS_TITLE",
        localize "STR_MKK_PTG_CAMERA_CONTROL_FORWARD_BACK",
        localize "STR_MKK_PTG_CAMERA_CONTROL_LEFT_RIGHT",
        localize "STR_MKK_PTG_CAMERA_CONTROL_UP",
        localize "STR_MKK_PTG_CAMERA_CONTROL_DOWN",
        localize "STR_MKK_PTG_CAMERA_CONTROL_SPEED",
        localize "STR_MKK_PTG_CAMERA_CONTROL_MOUSE",
        localize "STR_MKK_PTG_CAMERA_CONTROL_LOOK",
        localize "STR_MKK_PTG_CAMERA_CONTROL_WHEEL",
        localize "STR_MKK_PTG_CAMERA_CONTROL_SPEED_CHANGE",
        localize "STR_MKK_PTG_CAMERA_CONTROL_TOGGLE_HINT",
        localize "STR_MKK_PTG_CAMERA_CONTROL_CLOSE_NOTE"
    ];
    _text ctrlSetBackgroundColor [0, 0, 0, 0];
    _text ctrlCommit 0;

    missionNamespace setVariable ["mkk_ptg_mapCameraHintCtrls", [_bg, _text]];
};

private _display = findDisplay 46;
if !(isNull _display) then {
    private _mouseEH = _display displayAddEventHandler ["MouseMoving", {
        params ["_display", "_xDelta", "_yDelta"];
        if !(missionNamespace getVariable ["mkk_ptg_mapCameraRunning", false]) exitWith {};

        private _state = missionNamespace getVariable ["mkk_ptg_mapCameraState", createHashMap];
        private _dir = (_state getOrDefault ["dir", 0]) + (_xDelta * 0.35);
        private _pitch = ((_state getOrDefault ["pitch", -20]) - (_yDelta * 0.20)) max -89 min 89;

        _state set ["dir", _dir % 360];
        _state set ["pitch", _pitch];
    }];

    private _wheelEH = _display displayAddEventHandler ["MouseZChanged", {
        params ["_display", "_scroll"];
        if !(missionNamespace getVariable ["mkk_ptg_mapCameraRunning", false]) exitWith {};

        private _state = missionNamespace getVariable ["mkk_ptg_mapCameraState", createHashMap];
        private _speed = ((_state getOrDefault ["speed", 45]) + (_scroll * 5)) max 5 min 250;
        _state set ["speed", _speed];
    }];

    private _keyDownEH = _display displayAddEventHandler ["KeyDown", {
        params ["_display", "_key"];
        if !(missionNamespace getVariable ["mkk_ptg_mapCameraRunning", false]) exitWith {false};

        if (_key == DIK_F1) exitWith {
            private _visible = !(missionNamespace getVariable ["mkk_ptg_mapCameraHintVisible", true]);
            missionNamespace setVariable ["mkk_ptg_mapCameraHintVisible", _visible];

            private _hintCtrls = missionNamespace getVariable ["mkk_ptg_mapCameraHintCtrls", []];
            {
                if !(isNull _x) then {
                    _x ctrlShow _visible;
                };
            } forEach _hintCtrls;
            true
        };

        private _cameraKeys = [DIK_W, DIK_S, DIK_A, DIK_D, DIK_Q, DIK_Z, DIK_LSHIFT, DIK_RSHIFT];
        if !(_key in _cameraKeys) exitWith {false};

        private _state = missionNamespace getVariable ["mkk_ptg_mapCameraState", createHashMap];
        private _keys = _state getOrDefault ["keys", []];
        if !(_key in _keys) then {
            _keys pushBack _key;
            _state set ["keys", _keys];
        };
        true
    }];

    private _keyUpEH = _display displayAddEventHandler ["KeyUp", {
        params ["_display", "_key"];
        if !(missionNamespace getVariable ["mkk_ptg_mapCameraRunning", false]) exitWith {false};

        private _cameraKeys = [DIK_W, DIK_S, DIK_A, DIK_D, DIK_Q, DIK_Z, DIK_LSHIFT, DIK_RSHIFT];
        if !(_key in _cameraKeys) exitWith {false};

        private _state = missionNamespace getVariable ["mkk_ptg_mapCameraState", createHashMap];
        private _keys = _state getOrDefault ["keys", []];
        private _keyIndex = _keys find _key;
        if (_keyIndex >= 0) then {
            _keys deleteAt _keyIndex;
            _state set ["keys", _keys];
        };
        true
    }];

    missionNamespace setVariable ["mkk_ptg_mapCameraControlEHs", [_mouseEH, _wheelEH, _keyDownEH, _keyUpEH]];
};

[] spawn {
    private _lastTick = diag_tickTime;

    while {missionNamespace getVariable ["mkk_ptg_mapCameraRunning", false]} do {
        private _now = diag_tickTime;
        private _dt = (_now - _lastTick) max 0.001;
        _lastTick = _now;

        private _state = missionNamespace getVariable ["mkk_ptg_mapCameraState", createHashMap];
        private _camera = _state getOrDefault ["camera", objNull];
        if (isNull _camera) exitWith {};

        private _dir = _state getOrDefault ["dir", 0];
        private _pitch = _state getOrDefault ["pitch", -20];
        private _speed = _state getOrDefault ["speed", 45];
        private _keys = _state getOrDefault ["keys", []];

        private _multiplier = [1, 3] select (DIK_LSHIFT in _keys || {DIK_RSHIFT in _keys});
        private _step = _speed * _multiplier * _dt;

        private _pos = getPosATL _camera;
        private _forward = [sin _dir, cos _dir, 0];
        private _right = [cos _dir, -(sin _dir), 0];
        private _move = [0, 0, 0];

        if (DIK_W in _keys) then {_move = _move vectorAdd (_forward vectorMultiply _step);};
        if (DIK_S in _keys) then {_move = _move vectorDiff (_forward vectorMultiply _step);};
        if (DIK_D in _keys) then {_move = _move vectorAdd (_right vectorMultiply _step);};
        if (DIK_A in _keys) then {_move = _move vectorDiff (_right vectorMultiply _step);};
        if (DIK_Q in _keys) then {_move = _move vectorAdd [0, 0, _step];};
        if (DIK_Z in _keys) then {_move = _move vectorDiff [0, 0, _step];};

        private _nextPos = _pos vectorAdd _move;
        _nextPos set [2, ((_nextPos # 2) max 1) min 3000];

        _camera setPosATL _nextPos;
        _camera setDir _dir;
        [_camera, _pitch, 0] call BIS_fnc_setPitchBank;
        _camera camCommit 0;

        uiSleep 0.01;
    };

    if !(missionNamespace getVariable ["mkk_ptg_mapCameraRunning", false]) exitWith {};
    [] call FUNC(stopMapCamera);
};
