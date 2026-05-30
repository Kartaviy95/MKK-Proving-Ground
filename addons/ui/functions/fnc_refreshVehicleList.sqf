#include "..\script_component.hpp"
/*
    Refreshes the vehicle list from namespace-backed browser filters.
*/
private _sideFilter = uiNamespace getVariable ["mkk_ptg_vehicleFilterSide", -1];
if !(_sideFilter isEqualType 0) then {_sideFilter = parseNumber str _sideFilter;};

private _factionFilter = uiNamespace getVariable ["mkk_ptg_vehicleFilterFaction", ""];
if !(_factionFilter isEqualType "") then {_factionFilter = "";};

private _typeFilter = uiNamespace getVariable ["mkk_ptg_vehicleFilterType", ""];
if !(_typeFilter isEqualType "") then {_typeFilter = "";};

private _searchText = uiNamespace getVariable ["mkk_ptg_vehicleSearch", ""];
if !(_searchText isEqualType "") then {_searchText = "";};

private _filtered = [
    _sideFilter,
    _factionFilter,
    _typeFilter,
    _searchText
] call EFUNC(catalog,filterCatalog);
missionNamespace setVariable ["mkk_ptg_filteredCatalog", _filtered];

private _preferredClassName = missionNamespace getVariable ["mkk_ptg_currentSelection", ""];
private _preferredIndex = _filtered findIf {(_x # 0) isEqualTo _preferredClassName};

if ((count _filtered) > 0) then {
    if (_preferredIndex < 0) then {_preferredIndex = 0;};
    missionNamespace setVariable ["mkk_ptg_currentSelection", (_filtered # _preferredIndex) # 0];
} else {
    missionNamespace setVariable ["mkk_ptg_currentSelection", ""];
};

uiNamespace setVariable ["mkk_ptg_vehicleResultText", format [localize "STR_MKK_PTG_FOUND", count _filtered]];
[] call FUNC(refreshStaticAmmoBoxes);
