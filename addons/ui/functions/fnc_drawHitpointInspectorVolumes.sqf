#include "..\script_component.hpp"
/*
    Рисует опциональные 3D-точки hitpoints и их radius для текущей цели инспектора.
*/
if !(hasInterface) exitWith {};
if !(missionNamespace getVariable ["mkk_ptg_hitpointInspectorEnabled", false]) exitWith {};
if !(missionNamespace getVariable ["mkk_ptg_hitpointInspectorShowVolumes", false]) exitWith {};
if !(uiNamespace getVariable ["mkk_ptg_hitpointInspectorVisible", false]) exitWith {};
if (visibleMap || {!isNull (findDisplay 88000)} || {!isNull (findDisplay 88900)} || {!isNull (findDisplay 89000)}) exitWith {};

private _target = uiNamespace getVariable ["mkk_ptg_hitpointInspectorTarget", objNull];
if (isNull _target) exitWith {};

private _viewer = cameraOn;
if (isNull _viewer) then {
    _viewer = player;
};
if (isNull _viewer || {(_viewer distance _target) > 1200}) exitWith {};

private _allHitpoints = getAllHitPointsDamage _target;
if ((count _allHitpoints) < 3) exitWith {};

private _hpNames = _allHitpoints # 0;
private _hpSelections = _allHitpoints # 1;
if (_hpNames isEqualTo []) exitWith {};

private _hudScales = [] call EFUNC(common,getHudScale);
private _fontScale = (_hudScales # 1) max 0.85;
private _distance = _viewer distance _target;
private _lineWidth = linearConversion [30, 600, _distance, 5.5, 2.2, true];
private _labelSize = linearConversion [30, 600, _distance, 0.030, 0.018, true] * _fontScale;
private _ringSegments = 20;

private _className = typeOf _target;
private _hitpointsCfg = configFile >> "CfgVehicles" >> _className >> "HitPoints";

private _fncIsZeroPos = {
    params ["_pos"];

    ((abs (_pos # 0)) + (abs (_pos # 1)) + (abs (_pos # 2))) < 0.001
};

private _fncIsValidBoundingBox = {
    params ["_box", "_isZeroPos"];

    if !(_box isEqualType []) exitWith {false};
    if ((count _box) < 2) exitWith {false};

    private _min = _box # 0;
    private _max = _box # 1;
    if !(_min isEqualType [] && {_max isEqualType []}) exitWith {false};
    if ((count _min) < 3 || {(count _max) < 3}) exitWith {false};

    !([_min] call _isZeroPos) || {!([_max] call _isZeroPos)}
};

private _fncGetBoundingBoxCenter = {
    params ["_box"];

    private _min = _box # 0;
    private _max = _box # 1;

    [
        ((_min # 0) + (_max # 0)) / 2,
        ((_min # 1) + (_max # 1)) / 2,
        ((_min # 2) + (_max # 2)) / 2
    ]
};

private _fncExpandBoundingBox = {
    params ["_box", "_radius"];

    private _min = _box # 0;
    private _max = _box # 1;

    [
        [
            (_min # 0) - _radius,
            (_min # 1) - _radius,
            (_min # 2) - _radius
        ],
        [
            (_max # 0) + _radius,
            (_max # 1) + _radius,
            (_max # 2) + _radius
        ]
    ]
};

private _fncGetCategoryColor = {
    params ["_hpName", "_hpSelection", "_hpCfg"];

    private _key = toLowerANSI format [
        "%1 %2 %3 %4",
        _hpName,
        _hpSelection,
        getText (_hpCfg >> "name"),
        getText (_hpCfg >> "visual")
    ];
    private _color = [0.40, 1.00, 0.55, 0.96];

    if ((_key find "fuel") >= 0) then {
        _color = [1.00, 0.84, 0.10, 0.96];
    } else {
        if ((_key find "engine") >= 0) then {
            _color = [1.00, 0.12, 0.10, 0.96];
        } else {
            if ((_key find "wheel") >= 0 || {(_key find "tire") >= 0}) then {
                _color = [0.12, 0.52, 1.00, 0.96];
            } else {
                if ((_key find "track") >= 0) then {
                    _color = [0.04, 0.72, 1.00, 0.96];
                } else {
                    if ((_key find "turret") >= 0) then {
                        _color = [1.00, 0.48, 0.12, 0.96];
                    } else {
                        if ((_key find "gun") >= 0 || {(_key find "cannon") >= 0 || {(_key find "weapon") >= 0}}) then {
                            _color = [1.00, 0.24, 0.74, 0.96];
                        } else {
                            if ((_key find "hull") >= 0 || {(_key find "body") >= 0}) then {
                                _color = [0.86, 0.94, 1.00, 0.96];
                            } else {
                                if ((_key find "avionics") >= 0 || {(_key find "radar") >= 0 || {(_key find "sensor") >= 0}}) then {
                                    _color = [0.12, 1.00, 0.86, 0.96];
                                } else {
                                    if ((_key find "rotor") >= 0) then {
                                        _color = [0.70, 0.38, 1.00, 0.96];
                                    } else {
                                        if ((_key find "glass") >= 0 || {(_key find "window") >= 0}) then {
                                            _color = [0.62, 0.94, 1.00, 0.96];
                                        } else {
                                            if ((_key find "ammo") >= 0 || {(_key find "magazine") >= 0}) then {
                                                _color = [1.00, 0.92, 0.42, 0.96];
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
        };
    };

    _color
};

private _fncGetHitpointConfig = {
    params ["_cfgRoot", "_hpName"];

    private _cfg = _cfgRoot >> _hpName;
    if (isClass _cfg) exitWith {
        _cfg
    };

    private _hpKey = toLowerANSI _hpName;
    {
        if !(isClass _cfg) then {
            if ((toLowerANSI configName _x) isEqualTo _hpKey) then {
                _cfg = _x;
            };
        };
    } forEach ("true" configClasses _cfgRoot);

    _cfg
};

private _fncFindSelectionPosition = {
    params ["_veh", "_candidates", "_isZeroPos", "_isValidBoundingBox", "_getBoundingBoxCenter"];

    private _result = [false, [0, 0, 0], [0, 0, 0], [], "", ""];
    {
        if !(_result # 0) then {
            private _candidate = _x;
            {
                private _lod = _x;
                private _firstPos = _veh selectionPosition [_candidate, _lod, "FirstPoint"];
                private _avgPos = _veh selectionPosition [_candidate, _lod, "AveragePoint"];
                private _box = _veh selectionPosition [_candidate, _lod, "BoundingBox"];
                private _validBox = [_box, _isZeroPos] call _isValidBoundingBox;

                if (
                    !(_result # 0)
                    && {
                        !([_firstPos] call _isZeroPos)
                        || {!([_avgPos] call _isZeroPos)
                        || {_validBox}}
                    }
                ) then {
                    if ([_avgPos] call _isZeroPos) then {
                        _avgPos = _firstPos;
                    };
                    if (([_avgPos] call _isZeroPos) && {_validBox}) then {
                        _avgPos = [_box] call _getBoundingBoxCenter;
                    };
                    if ([_firstPos] call _isZeroPos) then {
                        _firstPos = _avgPos;
                    };

                    _result = [true, _firstPos, _avgPos, _box, _candidate, _lod];
                };
            } forEach ["HitPoints", "Memory", "Geometry", "FireGeometry", "ViewGeometry"];

            if !(_result # 0) then {
                private _fallbackPos = _veh selectionPosition _candidate;
                if !([_fallbackPos] call _isZeroPos) then {
                    _result = [true, _fallbackPos, _fallbackPos, [], _candidate, ""];
                };
            };
        };
    } forEach _candidates;

    _result
};

private _fncDrawModelLine = {
    params ["_veh", "_from", "_to", "_color", "_width"];

    drawLine3D [
        _veh modelToWorldVisual _from,
        _veh modelToWorldVisual _to,
        _color,
        _width
    ];
};

private _fncDrawCross = {
    params ["_veh", "_center", "_size", "_color", "_width", "_drawModelLine"];

    [_veh, [(_center # 0) - _size, _center # 1, _center # 2], [(_center # 0) + _size, _center # 1, _center # 2], _color, _width] call _drawModelLine;
    [_veh, [_center # 0, (_center # 1) - _size, _center # 2], [_center # 0, (_center # 1) + _size, _center # 2], _color, _width] call _drawModelLine;
    [_veh, [_center # 0, _center # 1, (_center # 2) - _size], [_center # 0, _center # 1, (_center # 2) + _size], _color, _width] call _drawModelLine;
};

private _fncDrawBox = {
    params ["_veh", "_box", "_color", "_width", "_drawModelLine"];

    private _min = _box # 0;
    private _max = _box # 1;
    private _corners = [
        [_min # 0, _min # 1, _min # 2],
        [_max # 0, _min # 1, _min # 2],
        [_max # 0, _max # 1, _min # 2],
        [_min # 0, _max # 1, _min # 2],
        [_min # 0, _min # 1, _max # 2],
        [_max # 0, _min # 1, _max # 2],
        [_max # 0, _max # 1, _max # 2],
        [_min # 0, _max # 1, _max # 2]
    ];
    private _edges = [
        [0, 1], [1, 2], [2, 3], [3, 0],
        [4, 5], [5, 6], [6, 7], [7, 4],
        [0, 4], [1, 5], [2, 6], [3, 7]
    ];

    {
        [_veh, _corners # (_x # 0), _corners # (_x # 1), _color, _width] call _drawModelLine;
    } forEach _edges;
};

private _fncDrawBoxFill = {
    params ["_veh", "_box", "_center", "_color", "_width", "_drawModelLine"];

    private _min = _box # 0;
    private _max = _box # 1;
    private _corners = [
        [_min # 0, _min # 1, _min # 2],
        [_max # 0, _min # 1, _min # 2],
        [_max # 0, _max # 1, _min # 2],
        [_min # 0, _max # 1, _min # 2],
        [_min # 0, _min # 1, _max # 2],
        [_max # 0, _min # 1, _max # 2],
        [_max # 0, _max # 1, _max # 2],
        [_min # 0, _max # 1, _max # 2]
    ];

    {
        [_veh, _center, _x, _color, _width] call _drawModelLine;
    } forEach _corners;
};

private _fncDrawRing = {
    params ["_veh", "_center", "_radius", "_plane", "_color", "_width", "_segments"];

    private _prevPos = [];
    for "_i" from 0 to _segments do {
        private _angle = _i * (360 / _segments);
        private _dx = 0;
        private _dy = 0;
        private _dz = 0;

        switch (_plane) do {
            case 0: {
                _dx = (sin _angle) * _radius;
                _dy = (cos _angle) * _radius;
            };
            case 1: {
                _dx = (sin _angle) * _radius;
                _dz = (cos _angle) * _radius;
            };
            default {
                _dy = (sin _angle) * _radius;
                _dz = (cos _angle) * _radius;
            };
        };

        private _curPos = [
            (_center # 0) + _dx,
            (_center # 1) + _dy,
            (_center # 2) + _dz
        ];

        if (_prevPos isNotEqualTo []) then {
            [_veh, _prevPos, _curPos, _color, _width] call _fncDrawModelLine;
        };

        _prevPos = _curPos;
    };
};

{
    private _hpName = _x;
    private _hpSelection = "";
    if (_forEachIndex < (count _hpSelections)) then {
        _hpSelection = _hpSelections # _forEachIndex;
    };

    private _hpCfg = [_hitpointsCfg, _hpName] call _fncGetHitpointConfig;
    private _radius = getNumber (_hpCfg >> "radius");
    private _candidateSelections = [];
    {
        if (_x isEqualType "" && {_x isNotEqualTo ""}) then {
            _candidateSelections pushBackUnique _x;
        };
    } forEach [
        _hpSelection,
        getText (_hpCfg >> "name"),
        getText (_hpCfg >> "visual"),
        _hpName
    ];

    private _selectionPos = [
        _target,
        _candidateSelections,
        _fncIsZeroPos,
        _fncIsValidBoundingBox,
        _fncGetBoundingBoxCenter
    ] call _fncFindSelectionPosition;
    if (_selectionPos # 0) then {
        private _firstPoint = _selectionPos # 1;
        private _center = _selectionPos # 2;
        private _box = _selectionPos # 3;
        private _color = [_hpName, _hpSelection, _hpCfg] call _fncGetCategoryColor;
        private _ringColor = +_color;
        _ringColor set [3, 0.54];
        private _boxColor = +_color;
        _boxColor set [3, 0.50];
        private _fillColor = +_color;
        _fillColor set [3, 0.20];
        private _coverageColor = +_color;
        _coverageColor set [3, 0.18];

        private _drawRadius = ((_radius max 0.02) min 12);
        private _pointSize = ((_drawRadius min 0.18) max 0.055);
        [_target, _firstPoint, _pointSize * 0.72, _boxColor, _lineWidth * 0.95, _fncDrawModelLine] call _fncDrawCross;
        [_target, _center, _pointSize, _color, _lineWidth * 1.18, _fncDrawModelLine] call _fncDrawCross;

        if ([_box, _fncIsZeroPos] call _fncIsValidBoundingBox) then {
            [_target, _box, _center, _fillColor, _lineWidth * 0.34, _fncDrawModelLine] call _fncDrawBoxFill;
            [_target, _box, _boxColor, _lineWidth * 0.90, _fncDrawModelLine] call _fncDrawBox;
            if (_radius > 0) then {
                private _coverageBox = [_box, _drawRadius] call _fncExpandBoundingBox;
                [_target, _coverageBox, _coverageColor, _lineWidth * 0.62, _fncDrawModelLine] call _fncDrawBox;
            };
        };

        if (_radius > 0) then {
            [_target, _center, _drawRadius, 0, _ringColor, _lineWidth * 0.95, _ringSegments] call _fncDrawRing;
            [_target, _center, _drawRadius, 1, _ringColor, _lineWidth * 0.95, _ringSegments] call _fncDrawRing;
            [_target, _center, _drawRadius, 2, _ringColor, _lineWidth * 0.95, _ringSegments] call _fncDrawRing;
        };

        private _labelOffset = ((_drawRadius max 0.14) min 1.3) + 0.06;
        private _labelPos = _target modelToWorldVisual [
            _center # 0,
            _center # 1,
            (_center # 2) + _labelOffset
        ];
        private _radiusText = [_radius, 2] call BIS_fnc_cutDecimals;
        private _label = format [
            "%1 | %2",
            _hpName,
            format [localize "STR_MKK_PTG_HITPOINT_INSPECTOR_RADIUS_LABEL", _radiusText]
        ];

        drawIcon3D [
            "",
            _color,
            _labelPos,
            0,
            0,
            0,
            _label,
            2,
            _labelSize,
            "RobotoCondensed",
            "center"
        ];
    };
} forEach _hpNames;
