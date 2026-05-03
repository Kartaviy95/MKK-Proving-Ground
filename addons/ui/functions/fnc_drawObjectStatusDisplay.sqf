#include "..\script_component.hpp"
/*
    Updates the local object status HUD while enabled.
*/
private _hideHud = {
    params [["_hud", displayNull]];

    if (isNull _hud) exitWith {};

    {
        private _ctrl = _hud displayCtrl _x;
        if !(isNull _ctrl) then {
            _ctrl ctrlShow false;
        };
    } forEach [88200, 88201, 88202, 88203];
};

if !(missionNamespace getVariable ["mkk_ptg_objectStatusDisplayEnabled", false]) exitWith {
    [uiNamespace getVariable ["mkk_ptg_objectStatusDisplayHud", displayNull]] call _hideHud;
};

private _hud = uiNamespace getVariable ["mkk_ptg_objectStatusDisplayHud", displayNull];
if (isNull _hud) then {
    private _layer = "mkk_ptg_objectStatusDisplayLayer" call BIS_fnc_rscLayer;
    _layer cutRsc ["MKK_PTG_ObjectStatusDisplayHUD", "PLAIN", 0, false];
    _hud = uiNamespace getVariable ["mkk_ptg_objectStatusDisplayHud", displayNull];
};
if (isNull _hud) exitWith {};

private _hudScales = [] call EFUNC(common,getHudScale);
private _hudScale = _hudScales # 0;
private _fontScale = _hudScales # 1;
private _fmtSize = {
    params ["_value"];
    str ([(_value * _fontScale * 1.5), 2] call BIS_fnc_cutDecimals)
};

if (visibleMap || {!isNull (findDisplay 88000)} || {!isNull (findDisplay 88900)}) exitWith {
    [_hud] call _hideHud;
};

private _target = cursorObject;
if (isNull _target) then {
    _target = cursorTarget;
};

if (isNull _target || {_target isEqualTo player}) exitWith {
    [_hud] call _hideHud;
};

{
    private _ctrl = _hud displayCtrl _x;
    if !(isNull _ctrl) then {
        _ctrl ctrlShow true;
    };
} forEach [88200, 88201, 88202, 88203];

private _viewer = cameraOn;
if (isNull _viewer) then {
    _viewer = player;
};

private _fncGetBool = {
    params ["_varName", "_default"];
    missionNamespace getVariable [_varName, _default]
};

private _showClass = ["mkk_ptg_objectStatusShowClass", true] call _fncGetBool;
private _showDistance = ["mkk_ptg_objectStatusShowDistance", true] call _fncGetBool;
private _showDamage = ["mkk_ptg_objectStatusShowDamage", true] call _fncGetBool;
private _showHitpoints = ["mkk_ptg_objectStatusShowHitpoints", false] call _fncGetBool;
private _showHpHull = ["mkk_ptg_objectStatusHpHull", true] call _fncGetBool;
private _showHpEngine = ["mkk_ptg_objectStatusHpEngine", true] call _fncGetBool;
private _showHpFuel = ["mkk_ptg_objectStatusHpFuel", true] call _fncGetBool;
private _showHpTurret = ["mkk_ptg_objectStatusHpTurret", true] call _fncGetBool;
private _showHpGun = ["mkk_ptg_objectStatusHpGun", true] call _fncGetBool;

private _distance = round (_viewer distance _target);
private _className = typeOf _target;
if (_className isEqualTo "") then {
    _className = localize "STR_MKK_PTG_UNKNOWN";
};

private _displayName = "";
private _cfg = configFile >> "CfgVehicles" >> _className;
if (isClass _cfg) then {
    _displayName = [getText (_cfg >> "displayName")] call EFUNC(common,localizeString);
};
if (_displayName isEqualTo "") then {
    _displayName = _className;
};
private _damage = damage _target;
private _damageValue = [_damage, 3] call BIS_fnc_cutDecimals;
private _damagePercent = round (_damage * 100);
private _damageColor = "#67E58B";
if (_damage >= 0.66) then {
    _damageColor = "#FF6B5E";
} else {
    if (_damage >= 0.33) then {
        _damageColor = "#FFD166";
    };
};

private _lines = [
    format ["<t size='%2' color='#7FD7FF'>%1</t>", localize "STR_MKK_PTG_OBJECT_STATUS_TITLE", [0.70] call _fmtSize],
    format ["<t size='%2' color='#FFFFFF'>%1</t>", _displayName, [0.92] call _fmtSize]
];

if (_showDistance) then {
    _lines pushBack format [
        "<t size='%4' color='#9FB6C2'>%1</t> <t size='%5' color='#FFFFFF'>%2 %3</t>",
        localize "STR_MKK_PTG_DISTANCE",
        _distance,
        localize "STR_MKK_PTG_METERS_SHORT",
        [0.64] call _fmtSize,
        [0.80] call _fmtSize
    ];
};

if (_showClass) then {
    _lines pushBack format [
        "<t size='%3' color='#9FB6C2'>%1</t> <t size='%4' color='#D7EEF8'>%2</t>",
        localize "STR_MKK_PTG_CLASS",
        _className,
        [0.64] call _fmtSize,
        [0.68] call _fmtSize
    ];
};

if (_showDamage) then {
    _lines pushBack format [
        "<t size='%5' color='#9FB6C2'>%1</t> <t size='%6' color='%4'>%2 (%3%%)</t>",
        localize "STR_MKK_PTG_TOTAL_DAMAGE",
        _damageValue,
        _damagePercent,
        _damageColor,
        [0.64] call _fmtSize,
        [0.80] call _fmtSize
    ];
};

if (_showHitpoints) then {
    private _allHitpoints = getAllHitPointsDamage _target;
    private _hpNames = [];
    private _hpDamages = [];

    if ((count _allHitpoints) >= 3) then {
        _hpNames = _allHitpoints # 0;
        _hpDamages = _allHitpoints # 2;
    };

    private _fncGetState = {
        params ["_damage"];

        private _stateText = localize "STR_MKK_PTG_STATE_NOMINAL";
        private _stateColor = "#67E58B";

        if (_damage >= 0.75) then {
            _stateText = localize "STR_MKK_PTG_STATE_CRITICAL";
            _stateColor = "#FF6B5E";
        } else {
            if (_damage >= 0.50) then {
                _stateText = localize "STR_MKK_PTG_STATE_HEAVY_DAMAGE";
                _stateColor = "#FF9A3C";
            } else {
                if (_damage >= 0.25) then {
                    _stateText = localize "STR_MKK_PTG_STATE_DAMAGED";
                    _stateColor = "#FFD166";
                };
            };
        };

        [_stateText, _stateColor]
    };

    private _fncFindHitpoint = {
        params ["_wantedNames"];

        private _result = [];
        {
            private _wanted = toLowerANSI _x;
            {
                if (_result isEqualTo [] && {(toLowerANSI _x) isEqualTo _wanted}) then {
                    private _damage = if (_forEachIndex < (count _hpDamages)) then {
                        _hpDamages # _forEachIndex
                    } else {
                        _target getHitPointDamage _x
                    };

                    _result = [_x, _damage];
                };
            } forEach _hpNames;
        } forEach _wantedNames;

        _result
    };

    private _hpRows = [];
    private _fncAddHitpointRow = {
        params ["_enabled", "_wantedNames", "_label"];
        if (!_enabled) exitWith {};

        private _found = [_wantedNames] call _fncFindHitpoint;
        if (_found isEqualTo []) exitWith {};

        private _damageClamped = ((_found # 1) min 1) max 0;
        private _percent = round (_damageClamped * 100);
        private _state = [_damageClamped] call _fncGetState;

        _hpRows pushBack format [
            "<t size='%5' color='#9FB6C2'>%1</t> <t size='%6' color='%4'>%2%% %3</t>",
            _label,
            _percent,
            _state # 0,
            _state # 1,
            [0.66] call _fmtSize,
            [0.70] call _fmtSize
        ];
    };

    [_showHpHull, ["HitHull", "HitBody"], localize "STR_MKK_PTG_HP_HULL"] call _fncAddHitpointRow;
    [_showHpEngine, ["HitEngine", "HitEngine1", "HitEngine2"], localize "STR_MKK_PTG_HP_ENGINE"] call _fncAddHitpointRow;
    [_showHpFuel, ["HitFuel", "HitFuel1", "HitFuel2"], localize "STR_MKK_PTG_HP_FUEL"] call _fncAddHitpointRow;
    [_showHpTurret, ["HitTurret", "HitTurret1", "HitTurret2"], localize "STR_MKK_PTG_HP_TURRET"] call _fncAddHitpointRow;
    [_showHpGun, ["HitGun", "HitGun1", "HitGun2"], localize "STR_MKK_PTG_HP_GUN"] call _fncAddHitpointRow;

    if (_hpRows isNotEqualTo []) then {
        _lines pushBack format ["<t size='%2' color='#7FD7FF'>%1</t>", localize "STR_MKK_PTG_HITPOINTS", [0.64] call _fmtSize];
        {
            _lines pushBack _x;
        } forEach _hpRows;
    };
};

private _lineCount = count _lines;
private _panelX = 0.75;
private _panelW = 0.20;
private _panelBottom = 0.82;

// Base height is only a first pass. The final height is measured from the rendered StructuredText below,
// so long object names/classes that wrap to several lines automatically expand the frame.
private _panelMinH = 0.22;
private _panelMaxH = 0.70;
private _panelH = ((0.11 + (_lineCount * 0.030)) min _panelMaxH) max _panelMinH;
private _panelY = _panelBottom - _panelH;

private _panelRect = [[_panelX, _panelY, _panelW, _panelH], _hudScale] call EFUNC(common,scaleRect);
_panelRect params ["_scaledPanelX", "_scaledPanelY", "_scaledPanelW", "_scaledPanelH"];
private _padX = 0.015 * safeZoneW * _hudScale;
private _padY = 0.015 * safeZoneH * _hudScale;
private _accentW = (0.004 * safeZoneW * _hudScale) max pixelW;
private _accentH = (0.004 * safeZoneH * _hudScale) max pixelH;

private _statusText = _hud displayCtrl 88203;
if !(isNull _statusText) then {
    private _textW = (_scaledPanelW - (_padX * 2)) max pixelW;
    private _textH = (_scaledPanelH - (_padY * 2)) max pixelH;

    _statusText ctrlSetPosition [_scaledPanelX + _padX, _scaledPanelY + _padY, _textW, _textH];
    _statusText ctrlSetStructuredText parseText (_lines joinString "<br/>");
    _statusText ctrlCommit 0;

    // Measure the real rendered text height after wrapping. This is safer than estimating by character count.
    private _requiredTextH = ctrlTextHeight _statusText;
    private _requiredPanelH = _requiredTextH + (_padY * 2);

    private _minRect = [[_panelX, _panelBottom - _panelMinH, _panelW, _panelMinH], _hudScale] call EFUNC(common,scaleRect);
    private _maxRect = [[_panelX, _panelBottom - _panelMaxH, _panelW, _panelMaxH], _hudScale] call EFUNC(common,scaleRect);
    private _scaledMinH = (_minRect # 3) max pixelH;
    private _scaledMaxH = (_maxRect # 3) max _scaledMinH;

    private _scaledBottom = _scaledPanelY + _scaledPanelH;
    _scaledPanelH = ((_requiredPanelH max _scaledMinH) min _scaledMaxH) max pixelH;
    _scaledPanelY = _scaledBottom - _scaledPanelH;

    _textW = (_scaledPanelW - (_padX * 2)) max pixelW;
    _textH = (_scaledPanelH - (_padY * 2)) max pixelH;
    _statusText ctrlSetPosition [_scaledPanelX + _padX, _scaledPanelY + _padY, _textW, _textH];
    _statusText ctrlCommit 0;
};

private _panel = _hud displayCtrl 88200;
if !(isNull _panel) then {
    _panel ctrlSetPosition [_scaledPanelX, _scaledPanelY, _scaledPanelW, _scaledPanelH];
    _panel ctrlCommit 0;
};

private _accentTop = _hud displayCtrl 88201;
if !(isNull _accentTop) then {
    _accentTop ctrlSetPosition [_scaledPanelX, _scaledPanelY, _scaledPanelW, _accentH];
    _accentTop ctrlCommit 0;
};

private _accentSide = _hud displayCtrl 88202;
if !(isNull _accentSide) then {
    _accentSide ctrlSetPosition [_scaledPanelX, _scaledPanelY, _accentW, _scaledPanelH];
    _accentSide ctrlCommit 0;
};

private _bounds = boundingBoxReal _target;
private _height = (((_bounds # 1) # 2) max 0.8) + 0.35;
private _bottomPos = _target modelToWorldVisual [0, 0, 0];
private _topPos = _target modelToWorldVisual [0, 0, _height];

drawLine3D [_bottomPos, _topPos, [0.10, 0.72, 0.92, 0.70]];
drawIcon3D [
    "",
    [0.65, 0.90, 1.00, 0.95],
    _topPos,
    0,
    0,
    0,
    ["", format ["%1 %2", _distance, localize "STR_MKK_PTG_METERS_SHORT"]] select _showDistance,
    2,
    0.035 * _fontScale,
    "RobotoCondensed",
    "center"
];
