#include "..\script_component.hpp"
/*
    Запускает простую свободную камеру.
    Управление: W/S/A/D движение, Q вверх, Z вниз, мышь для взгляда, колесо мыши для скорости, Shift для ускорения.
    N переключает ночное видение. F1 переключает overlay управления. Клавиша закрытия задается через CBA keybinds.
*/
if !(hasInterface) exitWith {};

params [
    ["_selectedMapPos", [], [[]]]
];

if (_selectedMapPos isEqualTo []) exitWith {
    [] call FUNC(stopMapCamera);
    closeDialog 0;

    missionNamespace setVariable ["mkk_ptg_mapCameraSelecting", true];
    missionNamespace setVariable ["mkk_ptg_mapCameraSelectedPos", []];

    hint localize "STR_MKK_PTG_CAMERA_SELECT_MAP_POINT";
    openMap [true, false];

    onMapSingleClick "
        if !(missionNamespace getVariable ['mkk_ptg_mapCameraSelecting', false]) exitWith {false};
        missionNamespace setVariable ['mkk_ptg_mapCameraSelectedPos', _pos];
        missionNamespace setVariable ['mkk_ptg_mapCameraSelecting', false];
        onMapSingleClick '';
        openMap [false, false];
        true
    ";

    [] spawn {
        waitUntil {
            uiSleep 0.05;
            !(missionNamespace getVariable ['mkk_ptg_mapCameraSelecting', false]) || {!visibleMap}
        };

        private _selectedPos = missionNamespace getVariable ["mkk_ptg_mapCameraSelectedPos", []];
        missionNamespace setVariable ["mkk_ptg_mapCameraSelecting", false];
        onMapSingleClick "";

        if (_selectedPos isEqualTo []) exitWith {};
        [_selectedPos] call ptg_ui_fnc_startMapCamera;
    };
};

[] call FUNC(stopMapCamera);

private _startPos = [_selectedMapPos # 0, _selectedMapPos # 1, 0];
private _camera = "camera" camCreate [_startPos # 0, _startPos # 1, ((_startPos # 2) max 0) + 20];
_camera cameraEffect ["Internal", "Back"];
showCinemaBorder false;
camUseNVG false;
missionNamespace setVariable ["mkk_ptg_mapCameraNightVision", false];

private _dir = getDirVisual player;
_camera setDir _dir;
[_camera, -20, 0] call BIS_fnc_setPitchBank;
_camera camCommit 0;

missionNamespace setVariable ["mkk_ptg_mapCameraState", createHashMapFromArray [
    ["camera", _camera],
    ["dir", _dir],
    ["pitch", -20],
    ["speed", 45],
    ["height", 20],
    ["keys", []],
    ["speedIndicatorUntil", 0]
]];
missionNamespace setVariable ["mkk_ptg_mapCameraRunning", true];

missionNamespace setVariable ["mkk_ptg_mapCameraHintVisible", true];

private _hintDisplay = findDisplay 46;
if !(isNull _hintDisplay) then {
    private _hintIdcs = [88910, 88911];
    {
        private _ctrl = _hintDisplay displayCtrl _x;
        if !(isNull _ctrl) then {
            ctrlDelete _ctrl;
        };
    } forEach _hintIdcs;

    {
        private _pos = ctrlPosition _x;
        _pos params ["_ctrlX", "_ctrlY", "_ctrlW", "_ctrlH"];
        if (
            (ctrlIDC _x) < 0
            && {_ctrlX > (safeZoneX + (safeZoneW * 0.55))}
            && {_ctrlY < (safeZoneY + (safeZoneH * 0.30))}
            && {_ctrlW > (safeZoneW * 0.20)}
            && {_ctrlH > (safeZoneH * 0.20)}
        ) then {
            ctrlDelete _x;
        };
    } forEach allControls _hintDisplay;

    {
        if !(isNull _x) then {
            ctrlDelete _x;
        };
    } forEach ((missionNamespace getVariable ["mkk_ptg_mapCameraHintCtrls", []]) + (uiNamespace getVariable ["mkk_ptg_mapCameraHintCtrls", []]));
    missionNamespace setVariable ["mkk_ptg_mapCameraHintCtrls", []];
    uiNamespace setVariable ["mkk_ptg_mapCameraHintCtrls", []];

    private _hudScales = [] call EFUNC(common,getHudScale);
    private _hudScale = _hudScales # 0;
    private _fontScale = _hudScales # 1;
    private _marginX = 0.014 * safeZoneW;
    private _marginY = 0.014 * safeZoneH;
    private _bgW = (0.37 * safeZoneW * _hudScale) min (safeZoneW - (_marginX * 2));
    private _bgH = (0.38 * safeZoneH * _hudScale) min (safeZoneH - (_marginY * 2));
    private _bgX = safeZoneX + safeZoneW - _bgW - _marginX;
    private _bgY = safeZoneY + _marginY;
    private _padX = 0.010 * safeZoneW * _hudScale;
    private _padY = 0.007 * safeZoneH * _hudScale;
    private _bgRect = [_bgX, _bgY, _bgW, _bgH];
    private _textRect = [_bgX + _padX, _bgY + _padY, _bgW - (_padX * 2), _bgH - (_padY * 2)];

    private _bg = _hintDisplay ctrlCreate ["RscText", 88910];
    _bg ctrlSetPosition _bgRect;
    _bg ctrlSetBackgroundColor [0, 0, 0, 0.30];
    _bg ctrlCommit 0;

    private _text = _hintDisplay ctrlCreate ["RscStructuredText", 88911];
    _text ctrlSetPosition _textRect;
    private _titleSize = str ([1.18 * _fontScale, 2] call BIS_fnc_cutDecimals);
    private _rowSize = str ([0.95 * _fontScale, 2] call BIS_fnc_cutDecimals);
    private _noteSize = str ([0.86 * _fontScale, 2] call BIS_fnc_cutDecimals);
    _text ctrlSetStructuredText parseText format [
        "<t align='center' size='%16' font='RobotoCondensedBold' color='#F2F2F2'>%1</t><br/>" +
        "<t size='%17' color='#FFFFFF'>W / S</t><t size='%17' color='#CFCFCF'>    %2</t><br/>" +
        "<t size='%17' color='#FFFFFF'>A / D</t><t size='%17' color='#CFCFCF'>    %3</t><br/>" +
        "<t size='%17' color='#FFFFFF'>Q</t><t size='%17' color='#CFCFCF'>        %4</t><br/>" +
        "<t size='%17' color='#FFFFFF'>Z</t><t size='%17' color='#CFCFCF'>        %5</t><br/>" +
        "<t size='%17' color='#FFFFFF'>Shift</t><t size='%17' color='#CFCFCF'>    %6</t><br/>" +
        "<t size='%17' color='#FFFFFF'>%7</t><t size='%17' color='#CFCFCF'>    %8</t><br/>" +
        "<t size='%17' color='#FFFFFF'>%9</t><t size='%17' color='#CFCFCF'>   %10</t><br/>" +
        "<t size='%17' color='#FFFFFF'>%11</t><t size='%17' color='#CFCFCF'>    %12</t><br/>" +
        "<t size='%17' color='#FFFFFF'>N</t><t size='%17' color='#CFCFCF'>        %13</t><br/>" +
        "<t size='%17' color='#FFFFFF'>F1</t><t size='%17' color='#CFCFCF'>       %14</t><br/>" +
        "<t align='center' size='%18' color='#DADADA'>%15</t>",
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
        localize "STR_MKK_PTG_CAMERA_CONTROL_LMB",
        localize "STR_MKK_PTG_CAMERA_CONTROL_RELOCATE",
        localize "STR_MKK_PTG_CAMERA_CONTROL_NIGHT_VISION",
        localize "STR_MKK_PTG_CAMERA_CONTROL_TOGGLE_HINT",
        localize "STR_MKK_PTG_CAMERA_CONTROL_CLOSE_NOTE",
        _titleSize,
        _rowSize,
        _noteSize
    ];
    _text ctrlSetBackgroundColor [0, 0, 0, 0];
    _text ctrlCommit 0;

    missionNamespace setVariable ["mkk_ptg_mapCameraHintCtrls", [_bg, _text]];
    uiNamespace setVariable ["mkk_ptg_mapCameraHintCtrls", [_bg, _text]];

    private _speedBgRect = [[0.405, 0.055, 0.19, 0.045], _hudScale] call EFUNC(common,scaleRect);
    private _speedTextRect = [[0.412, 0.062, 0.176, 0.034], _hudScale] call EFUNC(common,scaleRect);

    private _speedBg = _hintDisplay ctrlCreate ["RscText", -1];
    _speedBg ctrlSetPosition _speedBgRect;
    _speedBg ctrlSetBackgroundColor [0, 0, 0, 0.68];
    _speedBg ctrlShow false;
    _speedBg ctrlCommit 0;

    private _speedText = _hintDisplay ctrlCreate ["RscStructuredText", -1];
    _speedText ctrlSetPosition _speedTextRect;
    _speedText ctrlSetBackgroundColor [0, 0, 0, 0];
    _speedText ctrlShow false;
    _speedText ctrlCommit 0;

    missionNamespace setVariable ["mkk_ptg_mapCameraSpeedCtrls", [_speedBg, _speedText]];
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
        _state set ["speedIndicatorUntil", diag_tickTime + 1.2];

        private _speedCtrls = missionNamespace getVariable ["mkk_ptg_mapCameraSpeedCtrls", []];
        {
            if !(isNull _x) then {
                _x ctrlShow true;
            };
        } forEach _speedCtrls;

        if ((count _speedCtrls) > 1) then {
            private _speedText = _speedCtrls # 1;
            if !(isNull _speedText) then {
                _speedText ctrlSetStructuredText parseText format [
                    "<t align='center' size='1.05' font='RobotoCondensedBold' color='#F2F2F2'>%1</t>",
                    format [localize "STR_MKK_PTG_CAMERA_SPEED_VALUE", round _speed]
                ];
            };
        };
    }];


    private _mouseButtonEH = _display displayAddEventHandler ["MouseButtonDown", {
        params ["_display", "_button", "_xPos", "_yPos"];
        if !(missionNamespace getVariable ["mkk_ptg_mapCameraRunning", false]) exitWith {false};
        if (_button != 0) exitWith {false};

        private _state = missionNamespace getVariable ["mkk_ptg_mapCameraState", createHashMap];
        private _camera = _state getOrDefault ["camera", objNull];
        if (isNull _camera) exitWith {true};

        private _world = screenToWorld [_xPos, _yPos];
        if (_world isEqualTo [0,0,0]) exitWith {true};

        private _atl = ASLToATL (AGLToASL _world);
        private _height = ((_state getOrDefault ["height", 20]) max 2) min 3000;
        private _nextPos = [_atl # 0, _atl # 1, ((_atl # 2) max 0) + _height];
        _camera setPosATL _nextPos;
        _camera camCommit 0;
        true
    }];

    private _keyDownEH = _display displayAddEventHandler ["KeyDown", {
        params ["_display", "_key", "_shift", "_ctrl", "_alt"];
        if !(missionNamespace getVariable ["mkk_ptg_mapCameraRunning", false]) exitWith {false};

        if ([_key, _shift, _ctrl, _alt] call EFUNC(main,isCloseCameraKey)) exitWith {
            [] call EFUNC(main,closeActiveCamera);
            true
        };

        if (_key == DIK_N) exitWith {
            private _enabled = !(missionNamespace getVariable ["mkk_ptg_mapCameraNightVision", false]);
            missionNamespace setVariable ["mkk_ptg_mapCameraNightVision", _enabled];
            camUseNVG _enabled;
            true
        };

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

    missionNamespace setVariable ["mkk_ptg_mapCameraControlEHs", [_mouseEH, _wheelEH, _mouseButtonEH, _keyDownEH, _keyUpEH]];
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
        private _speedIndicatorUntil = _state getOrDefault ["speedIndicatorUntil", 0];
        if (_speedIndicatorUntil > 0 && {diag_tickTime > _speedIndicatorUntil}) then {
            private _speedCtrls = missionNamespace getVariable ["mkk_ptg_mapCameraSpeedCtrls", []];
            {
                if !(isNull _x) then {
                    _x ctrlShow false;
                };
            } forEach _speedCtrls;
            _state set ["speedIndicatorUntil", 0];
        };

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
