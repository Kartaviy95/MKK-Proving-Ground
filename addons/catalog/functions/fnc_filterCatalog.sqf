#include "..\script_component.hpp"
/*
    Фильтрует каталог по текущим параметрам UI.
*/
params [
    ["_sideFilter", -1],
    ["_factionFilter", ""],
    ["_nationFilter", ""],
    ["_typeFilter", ""],
    ["_searchText", ""]
];

private _search = toLowerANSI _searchText;
private _catalog = missionNamespace getVariable ["mkk_ptg_catalogCache", []];

private _filtered = _catalog select {
    private _className = _x # 0;
    private _displayName = [_x # 1] call EFUNC(common,localizeString);
    private _sideId = _x # 2;
    private _faction = _x # 3;
    private _nation = _x # 4;
    private _vehicleType = _x # 5;

    (_sideFilter < 0 || {_sideId isEqualTo _sideFilter})
    && (_factionFilter isEqualTo "" || {_faction isEqualTo _factionFilter})
    && (_nationFilter isEqualTo "" || {_nation isEqualTo _nationFilter})
    && (_typeFilter isEqualTo "" || {_vehicleType isEqualTo _typeFilter})
    && (_search isEqualTo "" || {(toLowerANSI _displayName) find _search > -1 || {(toLowerANSI _className) find _search > -1}})
};

missionNamespace setVariable ["mkk_ptg_filteredCatalog", _filtered];
_filtered
