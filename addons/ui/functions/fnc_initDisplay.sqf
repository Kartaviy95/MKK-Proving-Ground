#include "..\script_component.hpp"
/*
    Инициализация главного окна полигона.
*/
params ["_display"];

uiNamespace setVariable ["mkk_ptg_display", _display];
[_display] call EFUNC(common,applyDisplayScale);

{
    private _control = _display displayCtrl _x;
    if !(isNull _control) then {
        _control ctrlShow false;
    };
} forEach [88010, 88311];

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

private _crewSideId = _spawnState param [4, -1];
if !(_crewSideId isEqualType 0) then {
    _crewSideId = parseNumber str _crewSideId;
};
_crewSideId = round _crewSideId;
private _crewSideTouched = _spawnState param [5, false];
if !(_crewSideTouched isEqualType false) then {
    _crewSideTouched = false;
};
private _crewSideSaved = (_crewSideId in [0, 1, 2]) && {_crewSideTouched};
uiNamespace setVariable ["mkk_ptg_vehicleCrewSideTouched", _crewSideSaved];
if (_crewSideSaved) then {
    uiNamespace setVariable ["mkk_ptg_vehicleCrewSide", _crewSideId];
} else {
    [] call FUNC(updateVehicleCrewSideDefault);
};

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
uiNamespace setVariable ["mkk_ptg_targetCrewSideTouched", false];
[] call FUNC(updateTargetCrewSideDefault);
uiNamespace setVariable ["mkk_ptg_targetOverlayVisible", false];
uiNamespace setVariable ["mkk_ptg_rearmOverlayVisible", false];
uiNamespace setVariable ["mkk_ptg_dashboardVisible", true];
uiNamespace setVariable ["mkk_ptg_vehicleFiltersReady", false];
uiNamespace setVariable ["mkk_ptg_dashboardKeybindLabelsReady", false];

[] call FUNC(initInterfaceSizeCombo);
[] call FUNC(showDashboardView);
[_display] call FUNC(initWebDisplay);
