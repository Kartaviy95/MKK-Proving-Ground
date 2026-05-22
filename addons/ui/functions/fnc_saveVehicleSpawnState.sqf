#include "..\script_component.hpp"
/*
    Сохраняет последний выбор и параметры экрана создания техники.
*/
params [
    ["_persist", false]
];

private _className = missionNamespace getVariable ["mkk_ptg_currentSelection", ""];
if (_className isEqualTo "") exitWith {};
if !(isClass (configFile >> "CfgVehicles" >> _className)) exitWith {};

private _distance = missionNamespace getVariable ["mkk_ptg_spawnDefaultDistance", 10];
private _directionOffset = 0;
private _ammoBoxClass = missionNamespace getVariable ["mkk_ptg_currentAmmoBoxSelection", ""];

private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if !(isNull _display) then {
    private _distanceValue = parseNumber ctrlText (_display displayCtrl 88015);
    if (_distanceValue > 0) then {
        _distance = _distanceValue;
    };

    _directionOffset = parseNumber ctrlText (_display displayCtrl 88016);

    private _ctrlAmmoBox = _display displayCtrl 88017;
    private _ammoBoxIndex = lbCurSel _ctrlAmmoBox;
    if (_ammoBoxIndex >= 0) then {
        _ammoBoxClass = _ctrlAmmoBox lbData _ammoBoxIndex;
    };
};

private _maxDistance = missionNamespace getVariable ["mkk_ptg_spawnMaxDistance", 20000];
_distance = (_distance max 1) min _maxDistance;
_directionOffset = _directionOffset % 360;

if (_ammoBoxClass isNotEqualTo "" && {
    !(_className isKindOf "StaticWeapon")
    || {!isClass (configFile >> "CfgVehicles" >> _ammoBoxClass)}
    || {!(_ammoBoxClass isKindOf "ReammoBox_F" || {_ammoBoxClass isKindOf "ReammoBox"})}
}) then {
    _ammoBoxClass = "";
};
missionNamespace setVariable ["mkk_ptg_currentAmmoBoxSelection", _ammoBoxClass];

private _state = [_className, _distance, _directionOffset, _ammoBoxClass];
missionNamespace setVariable ["mkk_ptg_vehicleSpawnState", _state];

if (_persist) then {
    profileNamespace setVariable ["mkk_ptg_vehicleSpawnState", _state];
    saveProfileNamespace;
};
