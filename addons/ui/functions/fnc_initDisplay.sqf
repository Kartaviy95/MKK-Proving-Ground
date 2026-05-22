#include "..\script_component.hpp"
/*
    Инициализация главного окна полигона.
*/
params ["_display"];

uiNamespace setVariable ["mkk_ptg_display", _display];
[_display] call EFUNC(common,applyDisplayScale);

private _spawnState = missionNamespace getVariable [
    "mkk_ptg_vehicleSpawnState",
    profileNamespace getVariable ["mkk_ptg_vehicleSpawnState", []]
];
if !(_spawnState isEqualType []) then {
    _spawnState = [];
};

private _className = _spawnState param [0, ""];
if (_className isNotEqualTo "" && {!isClass (configFile >> "CfgVehicles" >> _className)}) then {
    _className = "";
};
missionNamespace setVariable ["mkk_ptg_currentSelection", _className];

private _distance = _spawnState param [1, missionNamespace getVariable ["mkk_ptg_spawnDefaultDistance", 10]];
if !(_distance isEqualType 0) then {
    _distance = missionNamespace getVariable ["mkk_ptg_spawnDefaultDistance", 10];
};

private _directionOffset = _spawnState param [2, 0];
if !(_directionOffset isEqualType 0) then {
    _directionOffset = 0;
};

private _ammoBoxClass = _spawnState param [3, ""];
if !(_ammoBoxClass isEqualType "") then {
    _ammoBoxClass = "";
};
missionNamespace setVariable ["mkk_ptg_currentAmmoBoxSelection", _ammoBoxClass];

(_display displayCtrl 88005) ctrlSetText format [localize "STR_MKK_PTG_VERSION", QUOTE(VERSION_STR)];
(_display displayCtrl 88015) ctrlSetText str _distance;
(_display displayCtrl 88016) ctrlSetText str _directionOffset;

[] call FUNC(refreshFilters);
[] call FUNC(initInterfaceSizeCombo);
[] call FUNC(showDashboardView);
