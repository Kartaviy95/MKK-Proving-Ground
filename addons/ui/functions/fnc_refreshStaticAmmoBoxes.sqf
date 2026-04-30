#include "..\script_component.hpp"
/*
    Обновляет список совместимых ammo boxes для выбранной статики.
*/
private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if (isNull _display) exitWith {};

private _ctrlLabel = _display displayCtrl 88057;
private _ctrlCombo = _display displayCtrl 88017;
private _className = missionNamespace getVariable ["mkk_ptg_currentSelection", ""];

lbClear _ctrlCombo;
missionNamespace setVariable ["mkk_ptg_currentAmmoBoxSelection", ""];

if (_className isEqualTo "" || {!(_className isKindOf "StaticWeapon")}) exitWith {
    _ctrlLabel ctrlShow false;
    _ctrlCombo ctrlShow false;
};

_ctrlLabel ctrlShow true;
_ctrlCombo ctrlShow true;
_ctrlCombo ctrlEnable true;

private _noneIdx = _ctrlCombo lbAdd localize "STR_MKK_PTG_NO_AMMO_BOX";
_ctrlCombo lbSetData [_noneIdx, ""];

private _boxes = [_className] call EFUNC(catalog,getCompatibleAmmoBoxes);

if (_boxes isEqualTo []) exitWith {
    private _idx = _ctrlCombo lbAdd localize "STR_MKK_PTG_NO_COMPATIBLE_AMMO_BOXES";
    _ctrlCombo lbSetData [_idx, ""];
    _ctrlCombo lbSetCurSel _idx;
    _ctrlCombo ctrlEnable false;
};

{
    _x params ["_boxClass", "_displayName", "_source"];

    private _idx = _ctrlCombo lbAdd format ["%1 | %2", _displayName, _source];
    _ctrlCombo lbSetData [_idx, _boxClass];
    _ctrlCombo lbSetTooltip [_idx, _boxClass];
} forEach _boxes;

_ctrlCombo lbSetCurSel _noneIdx;
