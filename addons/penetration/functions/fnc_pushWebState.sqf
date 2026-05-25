#include "..\script_component.hpp"
/*
    Provides browser views for the penetration and map-explosion tools.
*/
disableSerialization;
params [["_surface", "penetration", [""]]];

private _isExplosion = _surface isEqualTo "explosion";
private _display = uiNamespace getVariable [
    ["mkk_ptg_penetrationDisplay", "mkk_ptg_explosionDisplay"] select _isExplosion,
    displayNull
];
if (isNull _display) exitWith {};
if !(uiNamespace getVariable [format ["mkk_ptg_%1WebReady", _surface], false]) exitWith {};

private _browser = uiNamespace getVariable [format ["mkk_ptg_%1WebControl", _surface], controlNull];
if (isNull _browser) exitWith {};

private _fncOptions = {
    params ["_ctrl"];
    private _items = [];
    private _selected = lbCurSel _ctrl;
    for "_i" from 0 to ((lbSize _ctrl) - 1) do {
        _items pushBack [_ctrl lbData _i, _ctrl lbText _i, _i isEqualTo _selected];
    };
    _items
};

private _fncBasicRows = {
    params ["_ctrl"];
    private _rows = [];
    for "_i" from 0 to ((lbSize _ctrl) - 1) do {
        _rows pushBack [_ctrl lbData _i, _ctrl lbText _i, ""];
    };
    _rows
};

private _data = [];
if (!_isExplosion) then {
    private _selectedVehicle = missionNamespace getVariable ["mkk_ptg_penetrationVehicleClass", ""];
    private _vehicleRows = [];
    private _vehicleCtrl = _display displayCtrl 88920;
    for "_i" from 0 to ((lbSize _vehicleCtrl) - 1) do {
        private _className = _vehicleCtrl lbData _i;
        private _info = [_className] call EFUNC(catalog,getVehicleInfo);
        if (_info isNotEqualTo []) then {
            _vehicleRows pushBack [
                _className,
                [_info # 1] call EFUNC(common,localizeString),
                format ["%1 / %2", [_info # 4] call EFUNC(common,localizeString), _info param [11, _info # 3]]
            ];
        };
    };
    private _preview = "";
    if (_selectedVehicle isNotEqualTo "") then {
        private _vehicleCfg = configFile >> "CfgVehicles" >> _selectedVehicle;
        if (isClass _vehicleCfg) then {
            _preview = [_vehicleCfg] call EFUNC(common,getPreviewPath);
        };
    };
    private _vehicles = [ctrlText (_display displayCtrl 88910), _vehicleRows, _selectedVehicle, _preview];

    private _selectedAmmo = missionNamespace getVariable ["mkk_ptg_penetrationAmmoClass", ""];
    private _ammoCtrl = _display displayCtrl 88921;
    private _ammoRows = [];
    for "_i" from 0 to ((lbSize _ammoCtrl) - 1) do {
        private _className = _ammoCtrl lbData _i;
        private _cfg = configFile >> "CfgAmmo" >> _className;
        private _name = [_cfg, "displayName", _className] call EFUNC(common,getSafeConfigText);
        _name = [_name] call EFUNC(common,localizeString);
        if (_name isEqualTo "") then {_name = _className};
        _ammoRows pushBack [_className, _name, _className];
    };

    private _ammoCard = [];
    if (_selectedAmmo isNotEqualTo "") then {
        private _cfg = configFile >> "CfgAmmo" >> _selectedAmmo;
        if (isClass _cfg) then {
            private _submunition = [_cfg, "submunitionAmmo", ""] call EFUNC(common,getSafeConfigText);
            _submunition = if (_submunition isEqualTo "") then {
                localize "STR_MKK_PTG_NO"
            } else {
                format ["%1: %2", localize "STR_MKK_PTG_YES", _submunition]
            };
            _ammoCard = [
                localize "STR_MKK_PTG_AMMO_PARAMS",
                [localize "STR_MKK_PTG_CLASS", _selectedAmmo],
                [localize "STR_MKK_PTG_CALIBER", str ([_cfg, "caliber", 0] call EFUNC(common,getSafeConfigNumber))],
                [localize "STR_MKK_PTG_HIT", str ([_cfg, "hit", 0] call EFUNC(common,getSafeConfigNumber))],
                [localize "STR_MKK_PTG_INDIRECT_HIT", str ([_cfg, "indirectHit", 0] call EFUNC(common,getSafeConfigNumber))],
                [localize "STR_MKK_PTG_INDIRECT_HIT_RANGE", str ([_cfg, "indirectHitRange", 0] call EFUNC(common,getSafeConfigNumber))],
                [localize "STR_MKK_PTG_AIR_FRICTION", str ([_cfg, "airFriction", 0] call EFUNC(common,getSafeConfigNumber))],
                [localize "STR_MKK_PTG_SUBMUNITION_AMMO", _submunition]
            ];
        };
    };
    private _ammo = [ctrlText (_display displayCtrl 88911), _ammoRows, _selectedAmmo, _ammoCard];
    private _report = missionNamespace getVariable ["mkk_ptg_penetrationReport", ""];
    if (_report isEqualTo "") then {_report = localize "STR_MKK_PTG_DAMAGE_REPORT_EMPTY"};
    _data = [_vehicles, _ammo, _report];
} else {
    private _ammoClass = missionNamespace getVariable ["mkk_ptg_explosionAmmoClass", ""];
    private _info = [];
    if (_ammoClass isNotEqualTo "") then {
        private _cfg = configFile >> "CfgAmmo" >> _ammoClass;
        if (isClass _cfg) then {
            private _categoryKey = [_cfg] call FUNC(getExplosionAmmoCategory);
            private _category = if (_categoryKey isEqualTo "") then {localize "STR_MKK_PTG_UNKNOWN"} else {localize _categoryKey};
            private _submunition = [_cfg, "submunitionAmmo", ""] call EFUNC(common,getSafeConfigText);
            _submunition = if (_submunition isEqualTo "") then {
                localize "STR_MKK_PTG_NO"
            } else {
                format ["%1: %2", localize "STR_MKK_PTG_YES", _submunition]
            };
            _info = [
                _ammoClass,
                [localize "STR_MKK_PTG_EXPLOSION_CATEGORY", _category],
                [localize "STR_MKK_PTG_HIT", str ([_cfg, "hit", 0] call EFUNC(common,getSafeConfigNumber))],
                [localize "STR_MKK_PTG_INDIRECT_HIT", str ([_cfg, "indirectHit", 0] call EFUNC(common,getSafeConfigNumber))],
                [localize "STR_MKK_PTG_INDIRECT_HIT_RANGE", str ([_cfg, "indirectHitRange", 0] call EFUNC(common,getSafeConfigNumber))],
                [localize "STR_MKK_PTG_TYPICAL_SPEED", str ([_cfg, "typicalSpeed", 0] call EFUNC(common,getSafeConfigNumber))],
                [localize "STR_MKK_PTG_SUBMUNITION_AMMO", _submunition],
                [localize "STR_MKK_PTG_TRIGGER_DISTANCE", str ([_cfg, "triggerDistance", 0] call EFUNC(common,getSafeConfigNumber))]
            ];
        };
    };
    _data = [
        [(_display displayCtrl 89011)] call _fncOptions,
        [(_display displayCtrl 89020)] call _fncBasicRows,
        _ammoClass,
        ctrlText (_display displayCtrl 89010),
        ctrlText (_display displayCtrl 89031),
        _info
    ];
};

private _state = [_surface, [] call EFUNC(ui,getWebLabels), "", _data];
private _payload = _browser ctrlWebBrowserAction ["ToBase64", toJSON _state];
_browser ctrlWebBrowserAction ["ExecJS", format ["window.PTG.receiveBase64(""%1"");", _payload]];
