#include "..\script_component.hpp"
/*
    Строит кэш каталога техники.
*/
private _catalog = [];
private _cfgVehicles = configFile >> "CfgVehicles";

{
    private _cfg = _x;
    private _className = configName _cfg;

    if !(isClass _cfg) then {continue};
    if (getNumber (_cfg >> "scope") < 2) then {continue};

    private _simulation = [_cfg, "simulation", ""] call EFUNC(common,getSafeConfigText);
    if (_simulation in ["soldier", "thing", "fire", "house"]) then {continue};

    if !(
        _className isKindOf "LandVehicle"
        || {_className isKindOf "Air"}
        || {_className isKindOf "Ship"}
        || {_className isKindOf "StaticWeapon"}
    ) then {
        continue;
    };

    private _displayName = [_cfg, "displayName", _className] call EFUNC(common,getSafeConfigText);
    if (_displayName isEqualTo "") then {_displayName = _className;};

    private _sideId = [_cfg, "side", -1] call EFUNC(common,getSafeConfigNumber);
    private _faction = [_cfg, "faction", ""] call EFUNC(common,getSafeConfigText);
    private _nation = [_faction] call FUNC(getNationFromFaction);
    private _vehicleType = [_className] call FUNC(detectVehicleType);
    private _crewClass = [_cfg, "crew", ""] call EFUNC(common,getSafeConfigText);
    private _previewPath = [_cfg] call EFUNC(common,getPreviewPath);
    private _picturePath = [_cfg, "picture", ""] call EFUNC(common,getSafeConfigText);
    private _editorSubcategory = [_cfg, "editorSubcategory", ""] call EFUNC(common,getSafeConfigText);
    private _modSource = [_cfg] call EFUNC(common,getModSource);

    _catalog pushBack [
        _className,
        _displayName,
        _sideId,
        _faction,
        _nation,
        _vehicleType,
        _crewClass,
        _previewPath,
        _picturePath,
        _editorSubcategory,
        _modSource,
        _cfg
    ];
} forEach ("true" configClasses _cfgVehicles);

_catalog sort true;

missionNamespace setVariable ["mkk_ptg_catalogCache", _catalog];
missionNamespace setVariable ["mkk_ptg_filteredCatalog", +_catalog];

_catalog
