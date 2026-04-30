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
    _displayName = [_displayName] call EFUNC(common,localizeString);
    if (_displayName isEqualTo "") then {_displayName = _className;};

    private _sideId = [_cfg, "side", -1] call EFUNC(common,getSafeConfigNumber);
    private _faction = [_cfg, "faction", ""] call EFUNC(common,getSafeConfigText);
    private _factionDisplayName = _faction;
    private _factionCfg = configFile >> "CfgFactionClasses" >> _faction;
    if (isClass _factionCfg) then {
        _factionDisplayName = [_factionCfg, "displayName", _faction] call EFUNC(common,getSafeConfigText);
        _factionDisplayName = [_factionDisplayName] call EFUNC(common,localizeString);
    };
    if (_factionDisplayName isEqualTo "") then {_factionDisplayName = _faction;};

    private _vehicleType = [_className] call FUNC(detectVehicleType);
    private _crewClass = [_cfg, "crew", ""] call EFUNC(common,getSafeConfigText);
    private _previewPath = [_cfg] call EFUNC(common,getPreviewPath);
    private _picturePath = [_cfg, "picture", ""] call EFUNC(common,getSafeConfigText);
    private _editorSubcategory = [_cfg, "editorSubcategory", ""] call EFUNC(common,getSafeConfigText);
    private _editorSubcategoryDisplayName = _editorSubcategory;
    private _editorSubcategoryCfg = configFile >> "CfgEditorSubcategories" >> _editorSubcategory;
    if (isClass _editorSubcategoryCfg) then {
        _editorSubcategoryDisplayName = [_editorSubcategoryCfg, "displayName", _editorSubcategory] call EFUNC(common,getSafeConfigText);
        _editorSubcategoryDisplayName = [_editorSubcategoryDisplayName] call EFUNC(common,localizeString);
    };
    if (_editorSubcategoryDisplayName isEqualTo "") then {_editorSubcategoryDisplayName = _editorSubcategory;};

    private _modSource = [_cfg] call EFUNC(common,getModSource);

    _catalog pushBack [
        _className,
        _displayName,
        _sideId,
        _faction,
        _vehicleType,
        _crewClass,
        _previewPath,
        _picturePath,
        _editorSubcategory,
        _modSource,
        _cfg,
        _factionDisplayName,
        _editorSubcategoryDisplayName
    ];
} forEach ("true" configClasses _cfgVehicles);

_catalog sort true;

missionNamespace setVariable ["mkk_ptg_catalogCache", _catalog];
missionNamespace setVariable ["mkk_ptg_filteredCatalog", +_catalog];

_catalog
