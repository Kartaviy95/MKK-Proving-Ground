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

private _text = format [
    "<t size='0.70' color='#7FD7FF'>%1</t><br/><t size='0.92' color='#FFFFFF'>%2</t><br/><t size='0.64' color='#9FB6C2'>%3</t><br/><t size='0.80' color='#FFFFFF'>%4 %5</t><br/><t size='0.64' color='#9FB6C2'>%6</t><br/><t size='0.68' color='#D7EEF8'>%7</t><br/><t size='0.64' color='#9FB6C2'>%8</t><br/><t size='0.80' color='%11'>%9 (%10%%)</t>",
    localize "STR_MKK_PTG_OBJECT_STATUS_TITLE",
    _displayName,
    localize "STR_MKK_PTG_DISTANCE",
    _distance,
    localize "STR_MKK_PTG_METERS_SHORT",
    localize "STR_MKK_PTG_CLASS",
    _className,
    localize "STR_MKK_PTG_TOTAL_DAMAGE",
    _damageValue,
    _damagePercent,
    _damageColor
];

(_hud displayCtrl 88203) ctrlSetStructuredText parseText _text;

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
    format ["%1 %2", _distance, localize "STR_MKK_PTG_METERS_SHORT"],
    2,
    0.035,
    "RobotoCondensed",
    "center"
];
