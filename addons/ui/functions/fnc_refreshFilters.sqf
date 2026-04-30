#include "..\script_component.hpp"
/*
    Заполняет фильтры и обновляет список техники.
*/
params [
    ["_forceRebuild", false]
];

private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if (isNull _display) exitWith {};

private _catalog = missionNamespace getVariable ["mkk_ptg_catalogCache", []];
if (_forceRebuild || {_catalog isEqualTo []}) then {
    [] call EFUNC(catalog,buildVehicleCatalog);
    _catalog = missionNamespace getVariable ["mkk_ptg_catalogCache", []];
};

private _ctrlSide = _display displayCtrl 88011;
private _ctrlFaction = _display displayCtrl 88012;
private _ctrlNation = _display displayCtrl 88013;
private _ctrlType = _display displayCtrl 88014;

lbClear _ctrlSide;
lbClear _ctrlFaction;
lbClear _ctrlNation;
lbClear _ctrlType;

private _allSides = [[-1, localize "STR_MKK_PTG_ALL"]];
private _allFactions = [["", localize "STR_MKK_PTG_ALL"]];
private _allNations = [""];
private _allTypes = [""];

{
    private _sideId = _x # 2;
    private _faction = _x # 3;
    private _nation = _x # 4;
    private _vehicleType = _x # 5;
    private _factionDisplayName = _x param [12, _faction];

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
    if !(_nation in _allNations) then {_allNations pushBack _nation;};
    if !(_vehicleType in _allTypes) then {_allTypes pushBack _vehicleType;};
} forEach _catalog;

{
    private _idx = _ctrlSide lbAdd (_x # 1);
    _ctrlSide lbSetData [_idx, str (_x # 0)];
} forEach _allSides;

{
    private _idx = _ctrlFaction lbAdd (_x # 1);
    _ctrlFaction lbSetData [_idx, _x # 0];
} forEach _allFactions;

{
    private _label = [[_x] call EFUNC(common,localizeString), localize "STR_MKK_PTG_ALL"] select (_x isEqualTo "");
    private _idx = _ctrlNation lbAdd _label;
    _ctrlNation lbSetData [_idx, _x];
} forEach _allNations;

{
    private _label = [[_x] call EFUNC(common,localizeString), localize "STR_MKK_PTG_ALL"] select (_x isEqualTo "");
    private _idx = _ctrlType lbAdd _label;
    _ctrlType lbSetData [_idx, _x];
} forEach _allTypes;

_ctrlSide lbSetCurSel 0;
_ctrlFaction lbSetCurSel 0;
_ctrlNation lbSetCurSel 0;
_ctrlType lbSetCurSel 0;

[] call FUNC(refreshVehicleList);
