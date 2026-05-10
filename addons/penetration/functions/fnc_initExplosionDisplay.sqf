#include "..\script_component.hpp"
/*
    Initializes the map explosion tool.
*/
params ["_display"];

uiNamespace setVariable ["mkk_ptg_explosionDisplay", _display];
[_display] call EFUNC(common,applyDisplayScale);
missionNamespace setVariable ["mkk_ptg_explosionAmmoClass", ""];

private _ctrlHeight = _display displayCtrl 89031;
private _restoreHeight = missionNamespace getVariable ["mkk_ptg_explosionRestoreHeight", "300"];
_ctrlHeight ctrlSetText _restoreHeight;

private _ctrlSearch = _display displayCtrl 89010;
private _restoreSearch = missionNamespace getVariable ["mkk_ptg_explosionRestoreSearch", ""];
_ctrlSearch ctrlSetText _restoreSearch;

private _groups = [
    "STR_MKK_PTG_EXPLOSION_GROUP_BOMBS",
    "STR_MKK_PTG_EXPLOSION_GROUP_ROCKETS",
    "STR_MKK_PTG_EXPLOSION_GROUP_ATGM",
    "STR_MKK_PTG_EXPLOSION_GROUP_MORTARS"
];
private _restoreCategory = missionNamespace getVariable ["mkk_ptg_explosionRestoreCategory", ""];
if (_restoreCategory isEqualTo "") then {
    private _restoreAmmo = missionNamespace getVariable ["mkk_ptg_explosionRestoreAmmo", ""];
    if (_restoreAmmo != "" && {isClass (configFile >> "CfgAmmo" >> _restoreAmmo)}) then {
        _restoreCategory = [configFile >> "CfgAmmo" >> _restoreAmmo] call FUNC(getExplosionAmmoCategory);
    };
};

private _ctrlCategory = _display displayCtrl 89011;
lbClear _ctrlCategory;
private _selectedCategoryIdx = 0;
{
    private _idx = _ctrlCategory lbAdd localize _x;
    _ctrlCategory lbSetData [_idx, _x];
    if (_x isEqualTo _restoreCategory) then {
        _selectedCategoryIdx = _idx;
    };
} forEach _groups;
_ctrlCategory lbSetCurSel _selectedCategoryIdx;

private _ctrlMap = _display displayCtrl 89040;
_ctrlMap ctrlMapAnimAdd [0, 0.08, getPos player];
ctrlMapAnimCommit _ctrlMap;

[] call FUNC(refreshExplosionAmmoList);
[] call FUNC(updateExplosionAmmoInfo);
