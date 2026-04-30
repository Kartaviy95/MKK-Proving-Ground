#include "..\script_component.hpp"
/*
    Заполняет список техники для теста пробития.
*/
private _display = uiNamespace getVariable ["mkk_ptg_penetrationDisplay", displayNull];
if (isNull _display) exitWith {};

private _catalog = missionNamespace getVariable ["mkk_ptg_catalogCache", []];
if (_catalog isEqualTo []) then {
    [] call EFUNC(catalog,buildVehicleCatalog);
    _catalog = missionNamespace getVariable ["mkk_ptg_catalogCache", []];
};

private _ctrlSearch = _display displayCtrl 88910;
private _ctrlList = _display displayCtrl 88920;
private _search = toLowerANSI ctrlText _ctrlSearch;

lbClear _ctrlList;

{
    private _className = _x # 0;
    private _displayName = [_x # 1] call EFUNC(common,localizeString);
    private _vehicleType = [_x # 4] call EFUNC(common,localizeString);
    private _faction = _x param [11, _x # 3];

    if (_search isEqualTo "" || {(toLowerANSI _displayName) find _search > -1 || {(toLowerANSI _className) find _search > -1}}) then {
        private _idx = _ctrlList lbAdd format ["%1 | %2 | %3", _displayName, _vehicleType, _faction];
        _ctrlList lbSetData [_idx, _className];
    };
} forEach _catalog;

if ((lbSize _ctrlList) > 0) then {
    _ctrlList lbSetCurSel 0;
};
