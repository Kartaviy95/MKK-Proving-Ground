#include "..\script_component.hpp"
/*
    Builds browser filter options and refreshes the vehicle list.
*/
params [
    ["_forceRebuild", false]
];

private _catalog = missionNamespace getVariable ["mkk_ptg_catalogCache", []];
if (_forceRebuild || {_catalog isEqualTo []}) then {
    [] call EFUNC(catalog,buildVehicleCatalog);
    _catalog = missionNamespace getVariable ["mkk_ptg_catalogCache", []];
};

private _allSides = [[-1, localize "STR_MKK_PTG_ALL"]];
private _allFactions = [["", localize "STR_MKK_PTG_ALL"]];
private _allTypes = [["", localize "STR_MKK_PTG_ALL"]];

{
    private _sideId = _x # 2;
    private _faction = _x # 3;
    private _vehicleType = _x # 4;
    private _factionDisplayName = _x param [11, _faction];

    if ((_allSides findIf {(_x # 0) isEqualTo _sideId}) < 0) then {
        private _sideName = switch (_sideId) do {
            case 0: {localize "STR_MKK_PTG_OPFOR"};
            case 1: {localize "STR_MKK_PTG_BLUFOR"};
            case 2: {localize "STR_MKK_PTG_INDEPENDENT"};
            case 3: {localize "STR_MKK_PTG_CIVILIAN"};
            default {localize "STR_MKK_PTG_UNKNOWN"};
        };
        _allSides pushBack [_sideId, _sideName];
    };

    if ((_allFactions findIf {(_x # 0) isEqualTo _faction}) < 0) then {
        _allFactions pushBack [_faction, _factionDisplayName];
    };
    if ((_allTypes findIf {(_x # 0) isEqualTo _vehicleType}) < 0) then {
        _allTypes pushBack [_vehicleType, [_vehicleType] call EFUNC(common,localizeString)];
    };
} forEach _catalog;

uiNamespace setVariable ["mkk_ptg_vehicleSideOptions", _allSides];
uiNamespace setVariable ["mkk_ptg_vehicleFactionOptions", _allFactions];
uiNamespace setVariable ["mkk_ptg_vehicleTypeOptions", _allTypes];

if ((_allSides findIf {(_x # 0) isEqualTo (uiNamespace getVariable ["mkk_ptg_vehicleFilterSide", -1])}) < 0) then {
    uiNamespace setVariable ["mkk_ptg_vehicleFilterSide", -1];
};
if ((_allFactions findIf {(_x # 0) isEqualTo (uiNamespace getVariable ["mkk_ptg_vehicleFilterFaction", ""])}) < 0) then {
    uiNamespace setVariable ["mkk_ptg_vehicleFilterFaction", ""];
};
if ((_allTypes findIf {(_x # 0) isEqualTo (uiNamespace getVariable ["mkk_ptg_vehicleFilterType", ""])}) < 0) then {
    uiNamespace setVariable ["mkk_ptg_vehicleFilterType", ""];
};

[] call FUNC(refreshVehicleList);
