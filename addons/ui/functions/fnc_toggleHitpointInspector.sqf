#include "..\script_component.hpp"
/*
    Переключает локальный HUD, который сканирует значения damage для техники под прицелом игрока.
*/
if !(hasInterface) exitWith {};

private _enabledVarName = "mkk_ptg_hitpointInspectorEnabled";
private _pfhVarName = "mkk_ptg_hitpointInspectorPFH";
private _hudVarName = "mkk_ptg_hitpointInspectorHUD";
private _targetVarName = "mkk_ptg_hitpointInspectorTarget";
private _visibleVarName = "mkk_ptg_hitpointInspectorVisible";
private _workDataVarName = format ["%1_workData", _hudVarName];

private _fncRemovePFH = {
    params ["_pfhVarName"];

    private _oldPFH = missionNamespace getVariable [_pfhVarName, -1];
    if (_oldPFH >= 0) then {
        [_oldPFH] call CBA_fnc_removePerFrameHandler;
        missionNamespace setVariable [_pfhVarName, -1];
    };
};

private _fncDestroyHud = {
    params ["_hudVarName", "_targetVarName", "_visibleVarName", "_workDataVarName"];

    private _controls = uiNamespace getVariable [_hudVarName, []];
    {
        if (!isNull _x) then {
            ctrlDelete _x;
        };
    } forEach _controls;

    uiNamespace setVariable [_hudVarName, []];
    uiNamespace setVariable [_targetVarName, objNull];
    uiNamespace setVariable [_visibleVarName, false];
    uiNamespace setVariable [_workDataVarName, []];
};

private _enabled = !(missionNamespace getVariable [_enabledVarName, false]);
missionNamespace setVariable [_enabledVarName, _enabled];

if (!_enabled) exitWith {
    [_pfhVarName] call _fncRemovePFH;
    [_hudVarName, _targetVarName, _visibleVarName, _workDataVarName] call _fncDestroyHud;

    private _status = [localize "STR_MKK_PTG_DISABLED", localize "STR_MKK_PTG_ENABLED"] select false;
    [format [localize "STR_MKK_PTG_HITPOINT_INSPECTOR_STATUS", _status]] call EFUNC(main,showTimedHint);
};

if (isNull player) exitWith {
    missionNamespace setVariable [_enabledVarName, false];
    [localize "STR_MKK_PTG_HITPOINT_INSPECTOR_PLAYER_REQUIRED"] call EFUNC(main,showTimedHint);
};

if (isNull (findDisplay 46)) exitWith {
    missionNamespace setVariable [_enabledVarName, false];
    [localize "STR_MKK_PTG_HITPOINT_INSPECTOR_DISPLAY_MISSING"] call EFUNC(main,showTimedHint);
};

[_pfhVarName] call _fncRemovePFH;
[_hudVarName, _targetVarName, _visibleVarName, _workDataVarName] call _fncDestroyHud;

private _maxHitpointsToShow = 4;
private _scanDistance = 1200;
private _pfhDelay = 0.05;
private _radialSegments = 250;
private _radialOffColor = [0.10, 0.11, 0.13, 0.78];

private _pfh = [{
    params ["_args", "_handle"];

    _args params [
        "_pfhVarName",
        "_hudVarName",
        "_targetVarName",
        "_visibleVarName",
        "_workDataVarName",
        "_enabledVarName",
        "_maxHitpointsToShow",
        "_scanDistance",
        "_radialSegments",
        "_radialOffColor"
    ];

    disableSerialization;

    private _fncDestroyHud = {
        params ["_hudVarName", "_targetVarName", "_visibleVarName", "_workDataVarName"];

        private _controls = uiNamespace getVariable [_hudVarName, []];
        {
            if (!isNull _x) then {
                ctrlDelete _x;
            };
        } forEach _controls;

        uiNamespace setVariable [_hudVarName, []];
        uiNamespace setVariable [_targetVarName, objNull];
        uiNamespace setVariable [_visibleVarName, false];
        uiNamespace setVariable [_workDataVarName, []];
    };

    if !(missionNamespace getVariable [_enabledVarName, false]) exitWith {
        [_handle] call CBA_fnc_removePerFrameHandler;
        missionNamespace setVariable [_pfhVarName, -1];
        [_hudVarName, _targetVarName, _visibleVarName, _workDataVarName] call _fncDestroyHud;
    };

    private _display = findDisplay 46;
    if (isNull _display || {isNull player}) exitWith {};

    private _fncSetHudVisible = {
        params ["_controls", "_visible"];

        {
            if (!isNull _x) then {
                _x ctrlShow _visible;
            };
        } forEach _controls;
    };

    private _controls = uiNamespace getVariable [_hudVarName, []];
    private _isVisible = uiNamespace getVariable [_visibleVarName, false];

    if (visibleMap || {!isNull (findDisplay 88000)} || {!isNull (findDisplay 88900)}) exitWith {
        if (_isVisible) then {
            [_controls, false] call _fncSetHudVisible;
            uiNamespace setVariable [_visibleVarName, false];
        };
    };

    private _fncNormalizeVehicle = {
        params ["_obj"];

        if (isNull _obj) exitWith {
            objNull
        };

        private _veh = if (_obj isKindOf "CAManBase") then {
            vehicle _obj
        } else {
            _obj
        };

        if (isNull _veh) exitWith {
            objNull
        };

        if (_veh isKindOf "CAManBase") exitWith {
            objNull
        };

        if (
            (_veh isKindOf "LandVehicle")
            || {(_veh isKindOf "Air")
            || {(_veh isKindOf "Ship")
            || {_veh isKindOf "StaticWeapon"}}}
        ) exitWith {
            _veh
        };

        objNull
    };

    private _fncGetLookedVehicle = {
        params ["_scanDistance"];

        private _cursorVeh = [cursorObject] call _fncNormalizeVehicle;
        if (!isNull _cursorVeh && {(_cursorVeh distance player) <= _scanDistance}) exitWith {
            _cursorVeh
        };

        private _camStartASL = AGLToASL (positionCameraToWorld [0, 0, 0]);
        private _camEndASL = AGLToASL (positionCameraToWorld [0, 0, _scanDistance]);

        private _hits = lineIntersectsSurfaces [
            _camStartASL,
            _camEndASL,
            vehicle player,
            objNull,
            true,
            10,
            "GEOM",
            "VIEW",
            true
        ];

        private _result = objNull;
        {
            if (isNull _result) then {
                private _hitObj = _x # 2;
                private _parentObj = objNull;

                if ((count _x) > 3) then {
                    _parentObj = _x # 3;
                };

                private _veh = [_hitObj] call _fncNormalizeVehicle;
                if (isNull _veh) then {
                    _veh = [_parentObj] call _fncNormalizeVehicle;
                };

                if (!isNull _veh && {(_veh distance player) <= _scanDistance}) then {
                    _result = _veh;
                };
            };
        } forEach _hits;

        _result
    };

    private _fncGetHitpointLabel = {
        params ["_hpName"];

        switch (toLowerANSI _hpName) do {
            case "hithull": {localize "STR_MKK_PTG_HP_HULL"};
            case "hitbody": {localize "STR_MKK_PTG_HP_HULL"};
            case "hitengine": {localize "STR_MKK_PTG_HP_ENGINE"};
            case "hitengine1": {format [localize "STR_MKK_PTG_HP_ENGINE_NUMBER", 1]};
            case "hitengine2": {format [localize "STR_MKK_PTG_HP_ENGINE_NUMBER", 2]};
            case "hitfuel": {localize "STR_MKK_PTG_HP_FUEL"};
            case "hitfuel1": {format [localize "STR_MKK_PTG_HP_FUEL_NUMBER", 1]};
            case "hitfuel2": {format [localize "STR_MKK_PTG_HP_FUEL_NUMBER", 2]};
            case "hitturret": {localize "STR_MKK_PTG_HP_TURRET"};
            case "hitturret1": {format [localize "STR_MKK_PTG_HP_TURRET_NUMBER", 1]};
            case "hitturret2": {format [localize "STR_MKK_PTG_HP_TURRET_NUMBER", 2]};
            case "hitgun": {localize "STR_MKK_PTG_HP_GUN"};
            case "hitgun1": {format [localize "STR_MKK_PTG_HP_GUN_NUMBER", 1]};
            case "hitgun2": {format [localize "STR_MKK_PTG_HP_GUN_NUMBER", 2]};
            case "hitltrack": {localize "STR_MKK_PTG_HP_LEFT_TRACK"};
            case "hitrtrack": {localize "STR_MKK_PTG_HP_RIGHT_TRACK"};
            case "hitlfwheel": {localize "STR_MKK_PTG_HP_LEFT_FRONT_WHEEL"};
            case "hitrfwheel": {localize "STR_MKK_PTG_HP_RIGHT_FRONT_WHEEL"};
            case "hitlbwheel": {localize "STR_MKK_PTG_HP_LEFT_REAR_WHEEL"};
            case "hitrbwheel": {localize "STR_MKK_PTG_HP_RIGHT_REAR_WHEEL"};
            case "hitavionics": {localize "STR_MKK_PTG_HP_AVIONICS"};
            case "hithrotor": {localize "STR_MKK_PTG_HP_MAIN_ROTOR"};
            case "hitvrotor": {localize "STR_MKK_PTG_HP_TAIL_ROTOR"};
            case "hitglass1": {format [localize "STR_MKK_PTG_HP_GLASS_NUMBER", 1]};
            case "hitglass2": {format [localize "STR_MKK_PTG_HP_GLASS_NUMBER", 2]};
            case "hitglass3": {format [localize "STR_MKK_PTG_HP_GLASS_NUMBER", 3]};
            case "hitglass4": {format [localize "STR_MKK_PTG_HP_GLASS_NUMBER", 4]};
            case "hitglass5": {format [localize "STR_MKK_PTG_HP_GLASS_NUMBER", 5]};
            case "hitglass6": {format [localize "STR_MKK_PTG_HP_GLASS_NUMBER", 6]};
            default {_hpName};
        }
    };

    private _fncGetHitpoints = {
        params ["_veh", "_maxHitpointsToShow"];

        private _all = getAllHitPointsDamage _veh;
        private _names = [];
        private _damages = [];

        if ((count _all) >= 3) then {
            _names = _all # 0;
            _damages = _all # 2;
        };

        private _fullCount = count _names;
        if (_fullCount == 0) exitWith {
            [[], 0]
        };

        private _limit = if (_maxHitpointsToShow < 0) then {
            _fullCount
        } else {
            _maxHitpointsToShow min _fullCount
        };

        private _items = [];
        private _addedKeys = [];

        private _fncPushHitpoint = {
            params ["_item"];

            if ((count _item) == 0) exitWith {};
            if ((count _items) >= _limit) exitWith {};

            private _key = toLowerANSI (_item # 0);
            if (!(_key in _addedKeys)) then {
                _items pushBack _item;
                _addedKeys pushBack _key;
            };
        };

        private _fncFindHitpoint = {
            params ["_wantedNames", "_label"];

            private _result = [];
            private _foundIndex = -1;
            private _foundName = "";

            {
                private _wanted = toLowerANSI _x;
                {
                    if (_foundIndex < 0 && {(toLowerANSI _x) isEqualTo _wanted}) then {
                        _foundIndex = _forEachIndex;
                        _foundName = _x;
                    };
                } forEach _names;
            } forEach _wantedNames;

            if (_foundIndex >= 0) then {
                private _damage = if (_foundIndex < (count _damages)) then {
                    _damages # _foundIndex
                } else {
                    _veh getHitPointDamage _foundName
                };

                _result = [_foundName, _label, _damage];
            };

            _result
        };

        [[["HitHull", "HitBody"], localize "STR_MKK_PTG_HP_HULL"] call _fncFindHitpoint] call _fncPushHitpoint;
        [[["HitEngine", "HitEngine1", "HitEngine2"], localize "STR_MKK_PTG_HP_ENGINE"] call _fncFindHitpoint] call _fncPushHitpoint;
        [[["HitGun", "HitGun1", "HitGun2"], localize "STR_MKK_PTG_HP_GUN"] call _fncFindHitpoint] call _fncPushHitpoint;
        [[["HitTurret", "HitTurret1", "HitTurret2"], localize "STR_MKK_PTG_HP_TURRET"] call _fncFindHitpoint] call _fncPushHitpoint;

        if ((count _items) < _limit) then {
            {
                if ((count _items) < _limit) then {
                    private _key = toLowerANSI _x;
                    if (!(_key in _addedKeys)) then {
                        private _damage = if (_forEachIndex < (count _damages)) then {
                            _damages # _forEachIndex
                        } else {
                            _veh getHitPointDamage _x
                        };

                        _items pushBack [_x, [_x] call _fncGetHitpointLabel, _damage];
                        _addedKeys pushBack _key;
                    };
                };
            } forEach _names;
        };

        [_items, _fullCount]
    };

    private _fncFitStructuredTextSize = {
        params [
            "_text",
            "_baseSize",
            "_minSize",
            "_availableW",
            "_textScale",
            ["_maxChars", 52]
        ];

        private _safeText = str _text;
        private _textLen = count (toArray _safeText);
        private _fitChars = (((_availableW / (0.0030 * (_textScale max 0.85))) max 8) min _maxChars);

        (((_baseSize * (_fitChars / (_textLen max _fitChars))) max _minSize) min _baseSize)
    };

    private _fncCreateCtrl = {
        params ["_display", "_className", "_pos", "_bgColor"];

        private _ctrl = _display ctrlCreate [_className, -1];
        _ctrl ctrlSetPosition _pos;
        _ctrl ctrlSetBackgroundColor _bgColor;
        _ctrl ctrlSetFontHeight (0.038 * _fontScale);
        _ctrl ctrlCommit 0;

        _ctrl
    };

    private _fncCreateSegmentRing = {
        params [
            "_display",
            "_allControls",
            "_centerX",
            "_centerY",
            "_radiusY",
            "_segmentH",
            "_segmentCount",
            "_offColor"
        ];

        private _segments = [];
        private _xScale = pixelW / pixelH;
        private _radiusX = _radiusY * _xScale;
        private _segmentW = _segmentH * _xScale;

        for "_i" from 0 to (_segmentCount - 1) do {
            private _angle = _i * (360 / _segmentCount);
            private _x = _centerX + (sin _angle) * _radiusX - (_segmentW / 2);
            private _y = _centerY - (cos _angle) * _radiusY - (_segmentH / 2);

            private _seg = [
                _display,
                "RscText",
                [_x, _y, _segmentW, _segmentH],
                _offColor
            ] call _fncCreateCtrl;

            _allControls pushBack _seg;
            _segments pushBack _seg;
        };

        _segments
    };

    private _fncCreateRadialBlock = {
        params [
            "_display",
            "_allControls",
            "_cardX",
            "_cardY",
            "_cardW",
            "_cardH",
            "_title",
            "_subText",
            "_segmentCount",
            "_offColor"
        ];

        private _xScale = pixelW / pixelH;
        private _circleH = (_cardH * 0.64) min (_cardH - 0.034);
        _circleH = _circleH max (_cardH * 0.54);
        private _circleW = _circleH * _xScale;
        private _circleX = _cardX + 0.010;
        private _circleY = _cardY + ((_cardH - _circleH) / 2);
        private _centerX = _circleX + (_circleW / 2);
        private _centerY = _circleY + (_circleH / 2);
        private _segmentH = _circleH * 0.070;
        private _radiusY = (_circleH / 2) - (_segmentH * 0.85);

        private _ringSegments = [
            _display,
            _allControls,
            _centerX,
            _centerY,
            _radiusY,
            _segmentH,
            _segmentCount,
            _offColor
        ] call _fncCreateSegmentRing;

        private _percentTextH = _circleH * 0.42;
        private _percentTextY = _centerY - (_percentTextH / 2) - (_circleH * 0.055);
        private _percentText = [
            _display,
            "RscStructuredText",
            [
                _centerX - (_circleW / 2),
                _percentTextY,
                _circleW,
                _percentTextH
            ],
            [0, 0, 0, 0]
        ] call _fncCreateCtrl;

        _percentText ctrlSetStructuredText parseText format [
            "<t align='center' size='%1' color='#FFFFFF' shadow='1'>0</t>",
            (((1.12 * _uiTextScale) max 1.00) min 1.42) toFixed 2
        ];

        _allControls pushBack _percentText;

        private _textX = _circleX + _circleW + 0.010;
        private _textW = _cardW - (_textX - _cardX) - 0.014;
        private _titleSize = [
            _title,
            1.04 * _uiTextScale,
            0.64,
            _textW,
            _uiTextScale,
            48
        ] call _fncFitStructuredTextSize;
        private _titleH = ((_cardH * 0.30) max (0.030 * _uiTextScale)) min (_cardH * 0.38);
        private _titleY = _cardY + (0.006 * (_uiTextScale max 0.90));
        private _statusY = _titleY + _titleH + (0.003 * (_uiTextScale max 0.90));

        private _titleCtrl = [
            _display,
            "RscStructuredText",
            [_textX, _titleY, _textW, _titleH],
            [0, 0, 0, 0]
        ] call _fncCreateCtrl;

        _titleCtrl ctrlSetStructuredText parseText format [
            "<t size='%2' color='#FFFFFF' shadow='1'>%1</t>",
            _title,
            _titleSize toFixed 2
        ];

        _allControls pushBack _titleCtrl;

        private _statusCtrl = [
            _display,
            "RscStructuredText",
            [_textX, _statusY, _textW, (_cardY + _cardH) - _statusY - 0.006],
            [0, 0, 0, 0]
        ] call _fncCreateCtrl;

        _statusCtrl ctrlSetStructuredText parseText _subText;
        _allControls pushBack _statusCtrl;

        [
            _ringSegments,
            _percentText,
            _statusCtrl,
            _textW
        ]
    };

    private _fncBuildHud = {
        params [
            "_display",
            "_veh",
            "_hpList",
            "_hpFullCount",
            "_hudVarName",
            "_targetVarName",
            "_visibleVarName",
            "_radialSegments",
            "_radialOffColor"
        ];

        private _allControls = [];
        private _hpControls = [];

        private _hudScales = [] call EFUNC(common,getHudScale);
        private _hudScale = _hudScales # 0;
        private _fontScale = _hudScales # 1;

        private _interfaceSize = _hudScales # 3;
        private _layoutScale = (_hudScale max 0.88) min 1.30;
        private _textScale = (_fontScale max 1.00) min 1.35;
        private _uiTextScale = _textScale;

        /*
            Hit Points Inspector is a free HUD panel, not a child of the main
            dialog.  The main PTG interface size must therefore drive both the
            panel rectangle and the text sizes here.  The old layout capped the
            panel at ~46% safeZoneW, so on Large/Extra Large the font grew but
            the target card did not have enough room for displayName/classname.
        */
        private _panelW = linearConversion [0.85, 1.30, _interfaceSize, 0.42, 0.58, true];
        _panelW = (_panelW * _layoutScale) max 0.40;
        _panelW = _panelW min (safeZoneW * 0.68);

        private _pad = 0.016 * _layoutScale;
        private _gap = 0.012 * _layoutScale;
        private _headerH = 0.060 * _layoutScale;
        private _classH = 0.168 * _layoutScale;
        private _vehicleCardH = 0.164 * _layoutScale;
        private _hpCardH = 0.164 * _layoutScale;

        private _hpCount = count _hpList;
        private _hpGapCount = (_hpCount - 1) max 0;
        private _fncCalcPanelH = {
            _pad
            + _headerH + _gap
            + _classH + _gap
            + _vehicleCardH + _gap
            + (_hpCount * _hpCardH)
            + (_hpGapCount * _gap)
            + _pad
        };

        private _panelH = call _fncCalcPanelH;
        private _maxPanelH = safeZoneH - (0.030 * _layoutScale);
        if (_panelH > _maxPanelH) then {
            private _heightScale = ((_maxPanelH / _panelH) max 0.82) min 1.00;
            _gap = _gap * _heightScale;
            _headerH = _headerH * (_heightScale max 0.90);
            _classH = _classH * (_heightScale max 0.88);
            _vehicleCardH = _vehicleCardH * _heightScale;
            _hpCardH = _hpCardH * _heightScale;
            _panelH = call _fncCalcPanelH;
        };

        private _panelX = safeZoneX + safeZoneW - _panelW - (0.025 * _layoutScale);
        private _panelY = safeZoneY + ((safeZoneH - _panelH) / 2);

        if (_panelY < (safeZoneY + (0.015 * _hudScale))) then {
            _panelY = safeZoneY + (0.015 * _hudScale);
        };

        private _bg = [
            _display,
            "RscText",
            [_panelX, _panelY, _panelW, _panelH],
            [0.015, 0.018, 0.025, 0.88]
        ] call _fncCreateCtrl;

        _allControls pushBack _bg;

        private _accent = [
            _display,
            "RscText",
            [_panelX, _panelY, 0.0045 * _hudScale, _panelH],
            [0.20, 0.60, 1.00, 1.00]
        ] call _fncCreateCtrl;

        _allControls pushBack _accent;

        private _curY = _panelY + _pad;

        private _header = [
            _display,
            "RscText",
            [_panelX + _pad, _curY, _panelW - (_pad * 2), _headerH],
            [0.035, 0.095, 0.155, 0.96]
        ] call _fncCreateCtrl;

        _allControls pushBack _header;

        private _title = [
            _display,
            "RscStructuredText",
            [_panelX + _pad + (0.012 * _layoutScale), _curY + (0.010 * _layoutScale), _panelW - (_pad * 2) - (0.024 * _layoutScale), _headerH - (0.012 * _layoutScale)],
            [0, 0, 0, 0]
        ] call _fncCreateCtrl;

        _title ctrlSetStructuredText parseText format [
            "<t align='left' size='%2' color='#7CC8FF'>%1</t>",
            localize "STR_MKK_PTG_HITPOINT_INSPECTOR_TITLE",
            (((1.10 * _uiTextScale) max 0.98) min 1.38) toFixed 2
        ];

        _allControls pushBack _title;
        _curY = _curY + _headerH + _gap;

        private _classCard = [
            _display,
            "RscText",
            [_panelX + _pad, _curY, _panelW - (_pad * 2), _classH],
            [0.045, 0.050, 0.065, 0.86]
        ] call _fncCreateCtrl;

        _allControls pushBack _classCard;

        private _vehClass = typeOf _veh;
        private _vehName = getText (configFile >> "CfgVehicles" >> _vehClass >> "displayName");
        if (_vehName == "") then {
            _vehName = _vehClass;
        };

        private _shownCount = count _hpList;
        private _classContentW = _panelW - (_pad * 2) - (0.026 * _layoutScale);
        private _fitChars = (((_classContentW / (0.0031 * _layoutScale)) max 34) min 132);
        private _vehNameLen = count (toArray _vehName);
        private _vehClassLen = count (toArray _vehClass);
        private _nameTextSize = ((((1.04 * _uiTextScale) * (_fitChars / (_vehNameLen max _fitChars))) max 0.68) min (1.04 * _uiTextScale));
        private _classTextSize = ((((0.86 * _uiTextScale) * (_fitChars / (_vehClassLen max _fitChars))) max 0.58) min (0.86 * _uiTextScale));
        private _labelTextSize = (((0.84 * _uiTextScale) max 0.72) min 1.12);
        private _metaTextSize = (((0.78 * _uiTextScale) max 0.66) min 1.02);

        private _classText = [
            _display,
            "RscStructuredText",
            [_panelX + _pad + (0.014 * _layoutScale), _curY + (0.010 * _layoutScale), _classContentW, _classH - (0.014 * _layoutScale)],
            [0, 0, 0, 0]
        ] call _fncCreateCtrl;

        _classText ctrlSetStructuredText parseText format [
            "<t size='%7' color='#A8A8A8'>%1</t><br/><t size='%8' color='#FFFFFF'>%2</t><br/><t size='%9' color='#A8A8A8'>%3</t><br/><t size='%10' color='#A8A8A8'>%4 %5/%6</t>",
            localize "STR_MKK_PTG_HITPOINT_INSPECTOR_TARGET",
            _vehName,
            _vehClass,
            localize "STR_MKK_PTG_HITPOINTS",
            _shownCount,
            _hpFullCount,
            _labelTextSize toFixed 2,
            _nameTextSize toFixed 2,
            _classTextSize toFixed 2,
            _metaTextSize toFixed 2
        ];

        _allControls pushBack _classText;
        _curY = _curY + _classH + _gap;

        private _vehCard = [
            _display,
            "RscText",
            [_panelX + _pad, _curY, _panelW - (_pad * 2), _vehicleCardH],
            [0.055, 0.060, 0.075, 0.86]
        ] call _fncCreateCtrl;

        _allControls pushBack _vehCard;

        private _vehWidget = [
            _display,
            _allControls,
            _panelX + _pad,
            _curY,
            _panelW - (_pad * 2),
            _vehicleCardH,
            localize "STR_MKK_PTG_TOTAL_DAMAGE",
            format ["<t size='%2' color='#A8A8A8'>%1</t>", localize "STR_MKK_PTG_HITPOINT_INSPECTOR_WAITING", (((0.84 * _uiTextScale) max 0.74) min 1.08) toFixed 2],
            _radialSegments,
            _radialOffColor
        ] call _fncCreateRadialBlock;

        private _vehRingSegments = _vehWidget # 0;
        private _vehPercentText = _vehWidget # 1;
        private _vehDamageText = _vehWidget # 2;
        private _vehStatusTextW = _vehWidget # 3;

        _curY = _curY + _vehicleCardH + _gap;

        {
            private _hpName = _x # 0;
            private _hpLabel = _x # 1;

            private _card = [
                _display,
                "RscText",
                [_panelX + _pad, _curY, _panelW - (_pad * 2), _hpCardH],
                [0.055, 0.060, 0.075, 0.86]
            ] call _fncCreateCtrl;

            _allControls pushBack _card;

            private _widget = [
                _display,
                _allControls,
                _panelX + _pad,
                _curY,
                _panelW - (_pad * 2),
                _hpCardH,
                _hpLabel,
                format ["<t size='%2' color='#A8A8A8'>%1</t>", localize "STR_MKK_PTG_HITPOINT_INSPECTOR_WAITING", (((0.82 * _uiTextScale) max 0.72) min 1.06) toFixed 2],
                _radialSegments,
                _radialOffColor
            ] call _fncCreateRadialBlock;

            private _ringSegments = _widget # 0;
            private _percentText = _widget # 1;
            private _statusText = _widget # 2;
            private _statusTextW = _widget # 3;

            _hpControls pushBack [
                _hpName,
                _hpLabel,
                _statusText,
                _ringSegments,
                _percentText,
                _statusTextW
            ];

            _curY = _curY + _hpCardH + _gap;
        } forEach _hpList;

        uiNamespace setVariable [_hudVarName, _allControls];
        uiNamespace setVariable [_targetVarName, _veh];
        uiNamespace setVariable [_visibleVarName, true];

        [
            _allControls,
            _vehDamageText,
            _vehRingSegments,
            _vehPercentText,
            _vehStatusTextW,
            _hpControls,
            _interfaceSize
        ]
    };

    private _fncGetState = {
        params ["_damage"];

        private _stateText = localize "STR_MKK_PTG_STATE_NOMINAL";
        private _stateHex = "#66FF66";
        private _stateColor = [0.25, 1.00, 0.25, 0.95];

        if (_damage >= 0.75) then {
            _stateText = localize "STR_MKK_PTG_STATE_CRITICAL";
            _stateHex = "#FF4040";
            _stateColor = [1.00, 0.20, 0.20, 0.95];
        } else {
            if (_damage >= 0.50) then {
                _stateText = localize "STR_MKK_PTG_STATE_HEAVY_DAMAGE";
                _stateHex = "#FF9A3C";
                _stateColor = [1.00, 0.55, 0.20, 0.95];
            } else {
                if (_damage >= 0.25) then {
                    _stateText = localize "STR_MKK_PTG_STATE_DAMAGED";
                    _stateHex = "#FFD24A";
                    _stateColor = [1.00, 0.82, 0.25, 0.95];
                };
            };
        };

        [_stateText, _stateHex, _stateColor]
    };

    private _fncUpdateRing = {
        params [
            "_ringSegments",
            "_damage",
            "_activeColor",
            "_offColor"
        ];

        private _damageClamped = (_damage min 1) max 0;
        private _segmentCount = count _ringSegments;
        private _activeCount = round (_damageClamped * _segmentCount);

        {
            if (_forEachIndex < _activeCount) then {
                _x ctrlSetBackgroundColor _activeColor;
            } else {
                _x ctrlSetBackgroundColor _offColor;
            };

            _x ctrlCommit 0;
        } forEach _ringSegments;
    };

    private _targetVeh = [_scanDistance] call _fncGetLookedVehicle;
    private _currentHudTarget = uiNamespace getVariable [_targetVarName, objNull];
    _controls = uiNamespace getVariable [_hudVarName, []];
    _isVisible = uiNamespace getVariable [_visibleVarName, false];

    if (isNull _targetVeh) exitWith {
        if (_isVisible) then {
            [_controls, false] call _fncSetHudVisible;
            uiNamespace setVariable [_visibleVarName, false];
        };
    };

    private _hudMissing = (count _controls) == 0;
    if (!_hudMissing) then {
        _hudMissing = isNull (_controls # 0);
    };

    if (_targetVeh isNotEqualTo _currentHudTarget || {_hudMissing}) then {
        [_hudVarName, _targetVarName, _visibleVarName, _workDataVarName] call _fncDestroyHud;

        private _hpData = [_targetVeh, _maxHitpointsToShow] call _fncGetHitpoints;
        private _hpList = _hpData # 0;
        private _hpFullCount = _hpData # 1;

        private _newWorkData = [
            _display,
            _targetVeh,
            _hpList,
            _hpFullCount,
            _hudVarName,
            _targetVarName,
            _visibleVarName,
            _radialSegments,
            _radialOffColor
        ] call _fncBuildHud;

        uiNamespace setVariable [_workDataVarName, _newWorkData];

        _controls = uiNamespace getVariable [_hudVarName, []];
        _currentHudTarget = uiNamespace getVariable [_targetVarName, objNull];
    } else {
        if (!_isVisible) then {
            [_controls, true] call _fncSetHudVisible;
            uiNamespace setVariable [_visibleVarName, true];
        };
    };

    private _workData = uiNamespace getVariable [_workDataVarName, []];
    private _currentInterfaceSize = ([] call EFUNC(common,getHudScale)) # 3;
    private _builtInterfaceSize = if ((count _workData) > 6) then {_workData # 6} else {-1};
    private _interfaceScaleChanged = abs (_currentInterfaceSize - _builtInterfaceSize) > 0.01;

    if ((count _workData) == 0 || {_targetVeh isNotEqualTo _currentHudTarget || {_interfaceScaleChanged}}) then {
        [_hudVarName, _targetVarName, _visibleVarName, _workDataVarName] call _fncDestroyHud;

        private _hpData2 = [_targetVeh, _maxHitpointsToShow] call _fncGetHitpoints;
        private _hpList2 = _hpData2 # 0;
        private _hpFullCount2 = _hpData2 # 1;

        _workData = [
            _display,
            _targetVeh,
            _hpList2,
            _hpFullCount2,
            _hudVarName,
            _targetVarName,
            _visibleVarName,
            _radialSegments,
            _radialOffColor
        ] call _fncBuildHud;

        uiNamespace setVariable [_workDataVarName, _workData];
        _controls = uiNamespace getVariable [_hudVarName, []];
        _currentHudTarget = uiNamespace getVariable [_targetVarName, objNull];
    };

    _workData params [
        "_allControls",
        "_vehDamageText",
        "_vehRingSegments",
        "_vehPercentText",
        "_vehStatusTextW",
        "_hpControls",
        ["_builtInterfaceSize", -1]
    ];

    if ((count _allControls) == 0 || {isNull (_allControls # 0)}) exitWith {
        [_hudVarName, _targetVarName, _visibleVarName, _workDataVarName] call _fncDestroyHud;
    };

    private _liveHudScales = [] call EFUNC(common,getHudScale);
    private _liveTextScale = ((_liveHudScales # 1) max 1.00) min 1.35;

    private _vehDamage = damage _targetVeh;
    private _vehDamageClamped = (_vehDamage min 1) max 0;
    private _vehPercent = round (_vehDamageClamped * 100);

    private _vehState = [_vehDamageClamped] call _fncGetState;
    private _vehStateText = _vehState # 0;
    private _vehStateHex = _vehState # 1;
    private _vehStateColor = _vehState # 2;

    private _livePercentSize = (((1.12 * _liveTextScale) max 1.00) min 1.42);
    private _conditionSize = [
        localize "STR_MKK_PTG_CONDITION",
        0.82 * _liveTextScale,
        0.62,
        _vehStatusTextW,
        _liveTextScale,
        42
    ] call _fncFitStructuredTextSize;
    private _vehStateSize = [
        _vehStateText,
        1.00 * _liveTextScale,
        0.70,
        _vehStatusTextW,
        _liveTextScale,
        42
    ] call _fncFitStructuredTextSize;

    _vehDamageText ctrlSetStructuredText parseText format [
        "<t size='%4' color='#A8A8A8'>%1</t><br/><t size='%5' color='%2'>%3</t>",
        localize "STR_MKK_PTG_CONDITION",
        _vehStateHex,
        _vehStateText,
        _conditionSize toFixed 2,
        _vehStateSize toFixed 2
    ];

    _vehPercentText ctrlSetStructuredText parseText format [
        "<t align='center' size='%2' color='#FFFFFF' shadow='1'>%1</t>",
        _vehPercent,
        _livePercentSize toFixed 2
    ];

    [
        _vehRingSegments,
        _vehDamageClamped,
        _vehStateColor,
        _radialOffColor
    ] call _fncUpdateRing;

    {
        _x params [
            "_hpName",
            "_hpLabel",
            "_statusText",
            "_ringSegments",
            "_percentText",
            "_statusTextW"
        ];

        private _curDamage = _targetVeh getHitPointDamage _hpName;
        private _damageClamped = (_curDamage min 1) max 0;
        private _percent = round (_damageClamped * 100);

        private _state = [_damageClamped] call _fncGetState;
        private _stateText = _state # 0;
        private _stateHex = _state # 1;
        private _stateColor = _state # 2;

        private _hpNameSize = [
            _hpName,
            0.80 * _liveTextScale,
            0.58,
            _statusTextW,
            _liveTextScale,
            58
        ] call _fncFitStructuredTextSize;
        private _hpStateSize = [
            _stateText,
            1.02 * _liveTextScale,
            0.70,
            _statusTextW,
            _liveTextScale,
            42
        ] call _fncFitStructuredTextSize;

        _statusText ctrlSetStructuredText parseText format [
            "<t size='%4' color='#A8A8A8'>%1</t><br/><t size='%5' color='%2'>%3</t>",
            _hpName,
            _stateHex,
            _stateText,
            _hpNameSize toFixed 2,
            _hpStateSize toFixed 2
        ];

        _percentText ctrlSetStructuredText parseText format [
            "<t align='center' size='%2' color='#FFFFFF' shadow='1'>%1</t>",
            _percent,
            _livePercentSize toFixed 2
        ];

        [
            _ringSegments,
            _damageClamped,
            _stateColor,
            _radialOffColor
        ] call _fncUpdateRing;
    } forEach _hpControls;
}, _pfhDelay, [
    _pfhVarName,
    _hudVarName,
    _targetVarName,
    _visibleVarName,
    _workDataVarName,
    _enabledVarName,
    _maxHitpointsToShow,
    _scanDistance,
    _radialSegments,
    _radialOffColor
]] call CBA_fnc_addPerFrameHandler;

missionNamespace setVariable [_pfhVarName, _pfh];

private _status = [localize "STR_MKK_PTG_DISABLED", localize "STR_MKK_PTG_ENABLED"] select true;
[format [localize "STR_MKK_PTG_HITPOINT_INSPECTOR_STATUS", _status]] call EFUNC(main,showTimedHint);
