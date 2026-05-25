#include "..\script_component.hpp"
/*
    Serializes the existing SQF UI model into browser-friendly presentation data.
*/
disableSerialization;

private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if (isNull _display) exitWith {};
if !(uiNamespace getVariable ["mkk_ptg_webReady", false]) exitWith {};

private _browser = uiNamespace getVariable ["mkk_ptg_webControl", controlNull];
if (isNull _browser) exitWith {};

private _fncOptions = {
    params ["_ctrl"];
    private _items = [];
    if (isNull _ctrl) exitWith {_items};

    private _selected = lbCurSel _ctrl;
    for "_i" from 0 to ((lbSize _ctrl) - 1) do {
        _items pushBack [_ctrl lbData _i, _ctrl lbText _i, _i isEqualTo _selected];
    };
    _items
};

private _fncRows = {
    params ["_ctrl"];
    private _items = [];
    if (isNull _ctrl) exitWith {_items};

    for "_i" from 0 to ((lbSize _ctrl) - 1) do {
        _items pushBack [_ctrl lbData _i, _ctrl lbText _i, ""];
    };
    _items
};

private _fncSideText = {
    params ["_sideId"];
    switch (_sideId) do {
        case 0: {localize "STR_MKK_PTG_OPFOR"};
        case 1: {localize "STR_MKK_PTG_BLUFOR"};
        case 2: {localize "STR_MKK_PTG_INDEPENDENT"};
        case 3: {localize "STR_MKK_PTG_CIVILIAN"};
        default {localize "STR_MKK_PTG_UNKNOWN"};
    }
};

private _view = "vehicles";
if (uiNamespace getVariable ["mkk_ptg_dashboardVisible", true]) then {
    _view = "dashboard";
};
if (uiNamespace getVariable ["mkk_ptg_targetOverlayVisible", false]) then {
    _view = "targets";
};
if (uiNamespace getVariable ["mkk_ptg_rearmOverlayVisible", false]) then {
    _view = "rearm";
};

private _status = [
    missionNamespace getVariable ["mkk_ptg_trackingEnabled", false],
    missionNamespace getVariable ["mkk_ptg_trajectoryEnabled", false],
    missionNamespace getVariable ["mkk_ptg_mapProjectileMarkersEnabled", false],
    missionNamespace getVariable ["mkk_ptg_objectStatusDisplayEnabled", false],
    missionNamespace getVariable ["mkk_ptg_hitpointInspectorEnabled", false],
    missionNamespace getVariable ["mkk_ptg_infiniteAmmoEnabled", false],
    missionNamespace getVariable ["mkk_ptg_godModeEnabled", false],
    missionNamespace getVariable ["mkk_ptg_mapProjectileMarkerShowAmmo", false]
];

private _sizes = [];
private _sizeCtrl = _display displayCtrl 88131;
if !(isNull _sizeCtrl) then {
    private _selectedSize = lbCurSel _sizeCtrl;
    for "_i" from 0 to ((lbSize _sizeCtrl) - 1) do {
        _sizes pushBack [str (_sizeCtrl lbValue _i), _sizeCtrl lbText _i, _i isEqualTo _selectedSize];
    };
};

private _dashboard = [
    _status,
    !(isNull objectParent player),
    ctrlText (_display displayCtrl 88101),
    ctrlText (_display displayCtrl 88106),
    _sizes
];

private _vehicleRows = [];
private _vehicleList = _display displayCtrl 88020;
for "_i" from 0 to ((lbSize _vehicleList) - 1) do {
    private _className = _vehicleList lbData _i;
    private _info = [_className] call EFUNC(catalog,getVehicleInfo);
    if (_info isNotEqualTo []) then {
        private _name = [_info # 1] call EFUNC(common,localizeString);
        private _type = [_info # 4] call EFUNC(common,localizeString);
        private _faction = _info param [11, _info # 3];
        _vehicleRows pushBack [_className, _name, format ["%1 / %2", _type, _faction]];
    };
};

private _selectedVehicle = missionNamespace getVariable ["mkk_ptg_currentSelection", ""];
private _vehicleCard = [];
if (_selectedVehicle isNotEqualTo "") then {
    private _info = [_selectedVehicle] call EFUNC(catalog,getVehicleInfo);
    if (_info isNotEqualTo []) then {
        private _preview = [(_info # 10)] call EFUNC(common,getPreviewPath);
        _vehicleCard = [
            [_info # 1] call EFUNC(common,localizeString),
            _selectedVehicle,
            [_info # 2] call _fncSideText,
            _info param [11, _info # 3],
            [_info # 4] call EFUNC(common,localizeString),
            _info param [12, _info # 8],
            _info # 5,
            _info # 9,
            _preview
        ];
    };
};

private _showAmmoBox = _selectedVehicle isNotEqualTo "" && {_selectedVehicle isKindOf "StaticWeapon"};
private _vehicle = [
    [
        [(_display displayCtrl 88011)] call _fncOptions,
        [(_display displayCtrl 88012)] call _fncOptions,
        [(_display displayCtrl 88014)] call _fncOptions
    ],
    ctrlText (_display displayCtrl 88010),
    ctrlText (_display displayCtrl 88015),
    ctrlText (_display displayCtrl 88016),
    _vehicleRows,
    _selectedVehicle,
    _vehicleCard,
    [(_display displayCtrl 88017)] call _fncOptions,
    _showAmmoBox,
    ctrlText (_display displayCtrl 88002)
];

private _targetModeCtrl = _display displayCtrl 88310;
private _targetModeIndex = lbCurSel _targetModeCtrl;
private _targetMode = if (_targetModeIndex >= 0) then {_targetModeCtrl lbData _targetModeIndex} else {"bot"};
private _targetRows = [(_display displayCtrl 88320)] call _fncRows;
private _selectedTarget = missionNamespace getVariable ["mkk_ptg_targetSelection", ""];
private _targetCard = [];
if (_selectedTarget isNotEqualTo "") then {
    private _cfg = configFile >> "CfgVehicles" >> _selectedTarget;
    if (isClass _cfg) then {
        private _name = [_cfg, "displayName", _selectedTarget] call EFUNC(common,getSafeConfigText);
        _name = [_name] call EFUNC(common,localizeString);
        if (_name isEqualTo "") then {_name = _selectedTarget};
        _targetCard = [_name, _selectedTarget, [_cfg] call EFUNC(common,getPreviewPath)];
    };
};
private _targets = [
    [_targetModeCtrl] call _fncOptions,
    _targetMode,
    ctrlText (_display displayCtrl 88311),
    [
        ctrlText (_display displayCtrl 88315),
        ctrlText (_display displayCtrl 88316),
        ctrlText (_display displayCtrl 88317),
        ctrlText (_display displayCtrl 88318)
    ],
    _targetRows,
    _selectedTarget,
    _targetCard
];

private _rearmOpen = uiNamespace getVariable ["mkk_ptg_rearmOverlayVisible", false];
private _rearmVehicle = uiNamespace getVariable ["mkk_ptg_rearmVehicle", objNull];
private _rearmVehicleData = [];
if (_rearmOpen && {!isNull _rearmVehicle}) then {
    private _cfg = configOf _rearmVehicle;
    private _name = [getText (_cfg >> "displayName")] call EFUNC(common,localizeString);
    if (_name isEqualTo "") then {_name = typeOf _rearmVehicle};
    _rearmVehicleData = [_name, typeOf _rearmVehicle, [_cfg] call EFUNC(common,getPreviewPath)];
};

private _rearmMagazineCard = [];
private _selectedMagazine = uiNamespace getVariable ["mkk_ptg_rearmSelectedMagazine", ""];
if (_selectedMagazine isNotEqualTo "") then {
    private _magCfg = configFile >> "CfgMagazines" >> _selectedMagazine;
    private _ammo = [_magCfg, "ammo", ""] call EFUNC(common,getSafeConfigText);
    private _ammoName = _ammo;
    private _ammoCfg = configFile >> "CfgAmmo" >> _ammo;
    if (isClass _ammoCfg) then {
        private _displayAmmo = [getText (_ammoCfg >> "displayName")] call EFUNC(common,localizeString);
        if (_displayAmmo isNotEqualTo "") then {
            _ammoName = format ["%1 (%2)", _displayAmmo, _ammo];
        };
    };
    _rearmMagazineCard = [
        _selectedMagazine,
        _ammoName,
        str ([_magCfg, "count", 0] call EFUNC(common,getSafeConfigNumber)),
        [_magCfg, "pylonWeapon", ""] call EFUNC(common,getSafeConfigText)
    ];
};

private _fncSelectedData = {
    params ["_ctrl"];
    private _index = lbCurSel _ctrl;
    if (_index < 0) exitWith {""};
    _ctrl lbData _index
};
private _rearm = [
    _rearmOpen && {!isNull _rearmVehicle},
    _rearmVehicleData,
    [(_display displayCtrl 88220)] call _fncRows,
    [(_display displayCtrl 88220)] call _fncSelectedData,
    [(_display displayCtrl 88221)] call _fncRows,
    [(_display displayCtrl 88221)] call _fncSelectedData,
    [(_display displayCtrl 88222)] call _fncRows,
    [(_display displayCtrl 88222)] call _fncSelectedData,
    _rearmMagazineCard
];

private _trajectoryColor = missionNamespace getVariable ["mkk_ptg_trajectoryColorIndex", 0];
private _colors = [
    ["0", localize "STR_MKK_PTG_COLOR_CYAN", _trajectoryColor isEqualTo 0, "#1AD9FF"],
    ["1", localize "STR_MKK_PTG_COLOR_RED", _trajectoryColor isEqualTo 1, "#FF3333"],
    ["2", localize "STR_MKK_PTG_COLOR_YELLOW", _trajectoryColor isEqualTo 2, "#FFE640"],
    ["3", localize "STR_MKK_PTG_COLOR_GREEN", _trajectoryColor isEqualTo 3, "#36FF55"],
    ["4", localize "STR_MKK_PTG_COLOR_MAGENTA", _trajectoryColor isEqualTo 4, "#FF38FF"],
    ["5", localize "STR_MKK_PTG_COLOR_WHITE", _trajectoryColor isEqualTo 5, "#FFFFFF"]
];
private _trajectoryWidth = missionNamespace getVariable ["mkk_ptg_trajectoryLineWidth", 3];
private _widths = [];
{
    _widths pushBack [str _x, format [localize "STR_MKK_PTG_LINE_WIDTH_VALUE", _x], _x isEqualTo _trajectoryWidth];
} forEach [1, 2, 3, 5, 8];

private _hitpointsEnabled = missionNamespace getVariable ["mkk_ptg_objectStatusShowHitpoints", false];
private _objectSettings = [
    ["objectSetting", "class", localize "STR_MKK_PTG_CLASS", missionNamespace getVariable ["mkk_ptg_objectStatusShowClass", true], true],
    ["objectSetting", "distance", localize "STR_MKK_PTG_DISTANCE", missionNamespace getVariable ["mkk_ptg_objectStatusShowDistance", true], true],
    ["objectSetting", "damage", localize "STR_MKK_PTG_TOTAL_DAMAGE_SHORT", missionNamespace getVariable ["mkk_ptg_objectStatusShowDamage", true], true],
    ["objectSetting", "allowDamage", localize "STR_MKK_PTG_ALLOW_DAMAGE", missionNamespace getVariable ["mkk_ptg_objectStatusShowAllowDamage", true], true],
    ["objectSetting", "crew", localize "STR_MKK_PTG_CREW", missionNamespace getVariable ["mkk_ptg_objectStatusShowCrew", true], true],
    ["objectSetting", "hitpoints", localize "STR_MKK_PTG_HITPOINTS", _hitpointsEnabled, true],
    ["objectSetting", "hpHull", localize "STR_MKK_PTG_HP_HULL", missionNamespace getVariable ["mkk_ptg_objectStatusHpHull", true], _hitpointsEnabled],
    ["objectSetting", "hpEngine", localize "STR_MKK_PTG_HP_ENGINE", missionNamespace getVariable ["mkk_ptg_objectStatusHpEngine", true], _hitpointsEnabled],
    ["objectSetting", "hpFuel", localize "STR_MKK_PTG_HP_FUEL", missionNamespace getVariable ["mkk_ptg_objectStatusHpFuel", true], _hitpointsEnabled],
    ["objectSetting", "hpTurret", localize "STR_MKK_PTG_HP_TURRET", missionNamespace getVariable ["mkk_ptg_objectStatusHpTurret", true], _hitpointsEnabled],
    ["objectSetting", "hpGun", localize "STR_MKK_PTG_HP_GUN", missionNamespace getVariable ["mkk_ptg_objectStatusHpGun", true], _hitpointsEnabled]
];
private _inspectorSettings = [
    ["hitpointSetting", "hpEngine", localize "STR_MKK_PTG_HP_ENGINE", missionNamespace getVariable ["mkk_ptg_hitpointInspectorHpEngine", true], true],
    ["hitpointSetting", "hpHull", localize "STR_MKK_PTG_HP_HULL", missionNamespace getVariable ["mkk_ptg_hitpointInspectorHpHull", true], true],
    ["hitpointSetting", "hpTurret", localize "STR_MKK_PTG_HP_TURRET", missionNamespace getVariable ["mkk_ptg_hitpointInspectorHpTurret", true], true],
    ["hitpointSetting", "hpGun", localize "STR_MKK_PTG_HP_GUN", missionNamespace getVariable ["mkk_ptg_hitpointInspectorHpGun", true], true],
    ["hitpointSetting", "hpWheels", localize "STR_MKK_PTG_HP_WHEELS", missionNamespace getVariable ["mkk_ptg_hitpointInspectorHpWheels", false], true],
    ["hitpointSetting", "hpTracks", localize "STR_MKK_PTG_HP_TRACKS", missionNamespace getVariable ["mkk_ptg_hitpointInspectorHpTracks", false], true],
    ["hitpointSetting", "hpFuel", localize "STR_MKK_PTG_HP_FUEL", missionNamespace getVariable ["mkk_ptg_hitpointInspectorHpFuel", false], true],
    ["hitpointSetting", "showVolumes", localize "STR_MKK_PTG_HITPOINT_INSPECTOR_SHOW_VOLUMES", missionNamespace getVariable ["mkk_ptg_hitpointInspectorShowVolumes", false], true]
];
private _settings = [
    _colors,
    _widths,
    missionNamespace getVariable ["mkk_ptg_mapProjectileMarkerShowAmmo", false],
    _objectSettings,
    _inspectorSettings
];

private _state = [
    "main",
    [] call FUNC(getWebLabels),
    _view,
    _dashboard,
    _vehicle,
    _targets,
    _rearm,
    _settings
];
private _payload = _browser ctrlWebBrowserAction ["ToBase64", toJSON _state];
_browser ctrlWebBrowserAction ["ExecJS", format ["window.PTG.receiveBase64(""%1"");", _payload]];
