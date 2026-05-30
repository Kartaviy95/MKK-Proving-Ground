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
uiNamespace setVariable ["mkk_ptg_vehicleSearch", ""];
uiNamespace setVariable ["mkk_ptg_vehicleFilterSide", -1];
uiNamespace setVariable ["mkk_ptg_vehicleFilterFaction", ""];
uiNamespace setVariable ["mkk_ptg_vehicleFilterType", ""];
uiNamespace setVariable ["mkk_ptg_vehicleDistance", str _distance];
uiNamespace setVariable ["mkk_ptg_vehicleDirection", str _directionOffset];
uiNamespace setVariable ["mkk_ptg_vehicleAmmoBoxOptions", []];
uiNamespace setVariable ["mkk_ptg_vehicleResultText", localize "STR_MKK_PTG_FOUND_ZERO"];
uiNamespace setVariable ["mkk_ptg_targetMode", "bot"];
uiNamespace setVariable ["mkk_ptg_targetSearch", ""];
uiNamespace setVariable ["mkk_ptg_targetDistance", "5"];
uiNamespace setVariable ["mkk_ptg_targetPatrol", "50"];
uiNamespace setVariable ["mkk_ptg_targetAirRadius", "150"];
uiNamespace setVariable ["mkk_ptg_targetAirHeight", "100"];
uiNamespace setVariable ["mkk_ptg_targetRows", []];
missionNamespace setVariable ["mkk_ptg_targetSelection", ""];
uiNamespace setVariable ["mkk_ptg_targetOverlayVisible", false];
uiNamespace setVariable ["mkk_ptg_rearmOverlayVisible", false];
uiNamespace setVariable ["mkk_ptg_dashboardVisible", true];
uiNamespace setVariable ["mkk_ptg_vehicleFiltersReady", false];

[] call FUNC(initInterfaceSizeCombo);
[] call FUNC(showDashboardView);
[_display] call FUNC(initWebDisplay);
