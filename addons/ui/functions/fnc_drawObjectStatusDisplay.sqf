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
    format ["<t size='0.70' color='#7FD7FF'>%1</t>", localize "STR_MKK_PTG_OBJECT_STATUS_TITLE"],
    format ["<t size='0.92' color='#FFFFFF'>%1</t>", _displayName]
];

if (_showDistance) then {
    _lines pushBack format [
        "<t size='0.64' color='#9FB6C2'>%1</t> <t size='0.80' color='#FFFFFF'>%2 %3</t>",
        localize "STR_MKK_PTG_DISTANCE",
        _distance,
        localize "STR_MKK_PTG_METERS_SHORT"
    ];
};

if (_showClass) then {
    _lines pushBack format [
        "<t size='0.64' color='#9FB6C2'>%1</t> <t size='0.68' color='#D7EEF8'>%2</t>",
        localize "STR_MKK_PTG_CLASS",
        _className
    ];
};

if (_showDamage) then {
    _lines pushBack format [
        "<t size='0.64' color='#9FB6C2'>%1</t> <t size='0.80' color='%4'>%2 (%3%%)</t>",
        localize "STR_MKK_PTG_TOTAL_DAMAGE",
        _damageValue,
        _damagePercent,
        _damageColor
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
            "<t size='0.66' color='#9FB6C2'>%1</t> <t size='0.70' color='%4'>%2%% %3</t>",
            _label,
            _percent,
            _state # 0,
            _state # 1
        ];
    };

    [_showHpHull, ["HitHull", "HitBody"], localize "STR_MKK_PTG_HP_HULL"] call _fncAddHitpointRow;
    [_showHpEngine, ["HitEngine", "HitEngine1", "HitEngine2"], localize "STR_MKK_PTG_HP_ENGINE"] call _fncAddHitpointRow;
    [_showHpFuel, ["HitFuel", "HitFuel1", "HitFuel2"], localize "STR_MKK_PTG_HP_FUEL"] call _fncAddHitpointRow;
    [_showHpTurret, ["HitTurret", "HitTurret1", "HitTurret2"], localize "STR_MKK_PTG_HP_TURRET"] call _fncAddHitpointRow;
    [_showHpGun, ["HitGun", "HitGun1", "HitGun2"], localize "STR_MKK_PTG_HP_GUN"] call _fncAddHitpointRow;

    if (_hpRows isNotEqualTo []) then {
        _lines pushBack format ["<t size='0.64' color='#7FD7FF'>%1</t>", localize "STR_MKK_PTG_HITPOINTS"];
        {
            _lines pushBack _x;
        } forEach _hpRows;
    };
};

private _lineCount = count _lines;
private _panelX = 0.70;
private _panelW = 0.27;
private _panelBottom = 0.82;
private _panelH = (((0.11 + (_lineCount * 0.030)) min 0.58) max 0.22);
private _panelY = _panelBottom - _panelH;

private _panel = _hud displayCtrl 88200;
if !(isNull _panel) then {
    _panel ctrlSetPosition [_panelX, _panelY, _panelW, _panelH];
    _panel ctrlCommit 0;
};

private _accentTop = _hud displayCtrl 88201;
if !(isNull _accentTop) then {
    _accentTop ctrlSetPosition [_panelX, _panelY, _panelW, 0.004];
    _accentTop ctrlCommit 0;
};

private _accentSide = _hud displayCtrl 88202;
if !(isNull _accentSide) then {
    _accentSide ctrlSetPosition [_panelX, _panelY, 0.004, _panelH];
    _accentSide ctrlCommit 0;
};

private _statusText = _hud displayCtrl 88203;
if !(isNull _statusText) then {
    _statusText ctrlSetPosition [_panelX + 0.015, _panelY + 0.015, _panelW - 0.030, _panelH - 0.030];
    _statusText ctrlCommit 0;
    _statusText ctrlSetStructuredText parseText (_lines joinString "<br/>");
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
    0.035,
    "RobotoCondensed",
    "center"
];
