#include "..\script_component.hpp"
/*
    Обновляет список техники по текущим фильтрам.
*/
private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if (isNull _display) exitWith {};

private _ctrlSide = _display displayCtrl 88011;
private _ctrlFaction = _display displayCtrl 88012;
private _ctrlNation = _display displayCtrl 88013;
private _ctrlType = _display displayCtrl 88014;
private _ctrlSearch = _display displayCtrl 88010;
private _ctrlList = _display displayCtrl 88020;
private _ctrlCount = _display displayCtrl 88002;

private _sideFilter = parseNumber (_ctrlSide lbData (lbCurSel _ctrlSide));
private _factionFilter = _ctrlFaction lbData (lbCurSel _ctrlFaction);
private _nationFilter = _ctrlNation lbData (lbCurSel _ctrlNation);
private _typeFilter = _ctrlType lbData (lbCurSel _ctrlType);
private _searchText = ctrlText _ctrlSearch;

private _filtered = [
    _sideFilter,
    _factionFilter,
    _nationFilter,
    _typeFilter,
    _searchText
] call EFUNC(catalog,filterCatalog);

lbClear _ctrlList;

{
    private _className = _x # 0;
    private _displayName = [_x # 1] call EFUNC(common,localizeString);
    private _vehicleType = _x # 5;
    private _vehicleTypeLabel = [_vehicleType] call EFUNC(common,localizeString);
    private _factionDisplayName = _x param [12, _x # 3];

    private _idx = _ctrlList lbAdd format ["%1 | %2 | %3", _displayName, _vehicleTypeLabel, _factionDisplayName];
    _ctrlList lbSetData [_idx, _className];
} forEach _filtered;

_ctrlCount ctrlSetText format [localize "STR_MKK_PTG_FOUND", count _filtered];

if ((count _filtered) > 0) then {
    _ctrlList lbSetCurSel 0;
} else {
    missionNamespace setVariable ["mkk_ptg_currentSelection", ""];
    [] call FUNC(updateVehicleCard);
};
