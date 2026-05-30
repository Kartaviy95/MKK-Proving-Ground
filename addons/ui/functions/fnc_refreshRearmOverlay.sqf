#include "..\script_component.hpp"
/*
    Refreshes browser-backed rearm state.
*/
disableSerialization;

private _vehicle = objectParent player;
if (isNull _vehicle) exitWith {[] call FUNC(closeRearmOverlay)};

uiNamespace setVariable ["mkk_ptg_rearmVehicle", _vehicle];
uiNamespace setVariable ["mkk_ptg_rearmSelectedMode", "turret"];
uiNamespace setVariable ["mkk_ptg_rearmSelectedTurret", []];
uiNamespace setVariable ["mkk_ptg_rearmSelectedPylon", -1];
uiNamespace setVariable ["mkk_ptg_rearmSelectedPylonTurret", []];
uiNamespace setVariable ["mkk_ptg_rearmSelectedWeapon", ""];
uiNamespace setVariable ["mkk_ptg_rearmSelectedMagazine", ""];
uiNamespace setVariable ["mkk_ptg_rearmCompatibleMagazines", []];
uiNamespace setVariable ["mkk_ptg_rearmWeaponRows", []];
uiNamespace setVariable ["mkk_ptg_rearmMagazineRows", []];
uiNamespace setVariable ["mkk_ptg_rearmSelectedSlotIndex", -1];
uiNamespace setVariable ["mkk_ptg_rearmSelectedWeaponIndex", -1];
uiNamespace setVariable ["mkk_ptg_rearmSelectedMagazineIndex", -1];

private _vehicleCfg = configOf _vehicle;

private _fncTurretConfig = {
    params ["_baseCfg", "_path"];
    private _cfg = _baseCfg;
    {
        private _turrets = _cfg >> "Turrets";
        if (_x < count _turrets) then {
            _cfg = _turrets select _x;
        } else {
            _cfg = configNull;
        };
    } forEach _path;
    _cfg
};

private _fncSlotName = {
    params ["_cfg", "_path"];

    private _name = "";
    if (!isNull _cfg) then {
        _name = [getText (_cfg >> "gunnerName")] call EFUNC(common,localizeString);
        if (_name isEqualTo "") then {
            _name = [getText (_cfg >> "displayName")] call EFUNC(common,localizeString);
        };
        if (_name isEqualTo "") then {
            _name = configName _cfg;
        };

        private _role = "";
        if ((getNumber (_cfg >> "primaryGunner")) > 0) then {_role = localize "STR_MKK_PTG_REARM_GUNNER"};
        if ((getNumber (_cfg >> "primaryObserver")) > 0) then {_role = localize "STR_MKK_PTG_REARM_COMMANDER"};
        if ((getNumber (_cfg >> "primaryCommander")) > 0) then {_role = localize "STR_MKK_PTG_REARM_COMMANDER"};

        private _lowerName = toLower _name;
        private _lowerCfgName = toLower configName _cfg;
        if (_role isEqualTo "" && {(_lowerName find "loader") >= 0 || {(_lowerCfgName find "loader") >= 0} || {(_lowerName find "заряжа") >= 0}}) then {
            _role = localize "STR_MKK_PTG_CREW_LOADER";
        };

        if (_role isNotEqualTo "" && {(_name find _role) < 0}) then {
            _name = format ["%1 - %2", _role, _name];
        };
    };

    if (_name isEqualTo "") then {
        _name = format ["%1 %2", localize "STR_MKK_PTG_REARM_TURRET", _path];
    };

    _name
};

private _fncCollectTurretPaths = {
    params ["_cfg", ["_basePath", []]];

    private _paths = [];
    private _turretsCfg = _cfg >> "Turrets";
    for "_i" from 0 to ((count _turretsCfg) - 1) do {
        private _childCfg = _turretsCfg select _i;
        private _path = _basePath + [_i];
        _paths pushBack _path;
        _paths append ([_childCfg, _path] call _fncCollectTurretPaths);
    };

    _paths
};

private _turretPaths = [];
{
    if (!(_x in _turretPaths)) then {
        _turretPaths pushBack _x;
    };
} forEach ([_vehicleCfg, []] call _fncCollectTurretPaths);

{
    if (!(_x in _turretPaths)) then {
        _turretPaths pushBack _x;
    };
} forEach (allTurrets [_vehicle, true]);

private _turretRows = [];
{
    private _path = _x;
    private _cfg = [_vehicleCfg, _path] call _fncTurretConfig;
    private _weapons = (_vehicle weaponsTurret _path) select {_x isNotEqualTo ""};
    private _unit = _vehicle turretUnit _path;

    if (!isNull _cfg || {_weapons isNotEqualTo []} || {!isNull _unit}) then {
        private _name = [_cfg, _path] call _fncSlotName;
        _turretRows pushBack [_name, _path, _weapons, "turret"];
    };
} forEach _turretPaths;

private _driverWeapons = (_vehicle weaponsTurret [-1]) select {_x isNotEqualTo ""};
if (_driverWeapons isNotEqualTo []) then {
    _turretRows = [[localize "STR_MKK_PTG_REARM_DRIVER", [-1], _driverWeapons, "turret"]] + _turretRows;
};

private _pylonMagazines = getPylonMagazines _vehicle;
if (_pylonMagazines isNotEqualTo []) then {
    private _pylonCfgs = configProperties [_vehicleCfg >> "Components" >> "TransportPylonsComponent" >> "Pylons", "isClass _x"];
    {
        private _pylonIndex = _forEachIndex + 1;
        private _pylonCfg = configNull;
        private _pylonTurret = [];
        if (_forEachIndex < count _pylonCfgs) then {
            _pylonCfg = _pylonCfgs # _forEachIndex;
            _pylonTurret = getArray (_pylonCfg >> "turret");
        };
        private _pylonName = if (isNull _pylonCfg) then {format [localize "STR_MKK_PTG_REARM_PYLON", _pylonIndex]} else {configName _pylonCfg};
        private _currentMagazine = _x;
        private _displayMagazine = _currentMagazine;
        if (_displayMagazine isEqualTo "") then {_displayMagazine = localize "STR_MKK_PTG_REARM_PYLON_EMPTY"};
        _turretRows pushBack [format ["%1: %2", _pylonName, _displayMagazine], [_pylonIndex, _pylonTurret], [_currentMagazine], "pylon"];
    } forEach _pylonMagazines;
};

uiNamespace setVariable ["mkk_ptg_rearmTurrets", _turretRows];
private _slotRows = [];
{
    _slotRows pushBack [str _forEachIndex, _x # 0, ""];
} forEach _turretRows;
uiNamespace setVariable ["mkk_ptg_rearmSlotRows", _slotRows];

if (_turretRows isNotEqualTo []) then {
    [0] call FUNC(onRearmTurretSelected);
};
