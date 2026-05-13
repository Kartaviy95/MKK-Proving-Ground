#include "..\script_component.hpp"
/*
    Refreshes grouped ammo list for the explosion tool.
*/
private _display = uiNamespace getVariable ["mkk_ptg_explosionDisplay", displayNull];
if (isNull _display) exitWith {};

private _ctrlSearch = _display displayCtrl 89010;
private _ctrlCategory = _display displayCtrl 89011;
private _ctrlList = _display displayCtrl 89020;
private _search = toLower ctrlText _ctrlSearch;
private _categoryIdx = lbCurSel _ctrlCategory;
private _categoryKey = if (_categoryIdx >= 0) then {_ctrlCategory lbData _categoryIdx} else {"STR_MKK_PTG_EXPLOSION_GROUP_BOMBS"};

lbClear _ctrlList;

private _catalog = [] call FUNC(buildExplosionAmmoCatalog);
private _preferredAmmo = missionNamespace getVariable ["mkk_ptg_explosionRestoreAmmo", ""];
private _firstAmmoIdx = -1;
private _preferredAmmoIdx = -1;

{
    if (
        (_x # 0) isEqualTo _categoryKey
        && {
            _search isEqualTo ""
            || {_search in (toLower (_x # 1))}
            || {_search in (toLower (_x # 2))}
        }
    ) then {
        private _idx = _ctrlList lbAdd format ["%1 | %2", _x # 1, _x # 2];
        _ctrlList lbSetData [_idx, _x # 2];
        if (_firstAmmoIdx < 0) then {_firstAmmoIdx = _idx;};
        if ((_x # 2) isEqualTo _preferredAmmo) then {_preferredAmmoIdx = _idx;};
    };
} forEach _catalog;

private _selectIdx = [_firstAmmoIdx, _preferredAmmoIdx] select (_preferredAmmoIdx >= 0);
if (_selectIdx >= 0) then {
    _ctrlList lbSetCurSel _selectIdx;
    [_ctrlList, _selectIdx] call FUNC(onExplosionAmmoSelected);
} else {
    missionNamespace setVariable ["mkk_ptg_explosionAmmoClass", ""];
    [] call FUNC(updateExplosionAmmoInfo);
};
