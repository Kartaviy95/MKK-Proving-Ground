#include "..\script_component.hpp"
/*
    Отправляет запрос на создание выбранной цели.
*/
private _mode = uiNamespace getVariable ["mkk_ptg_targetMode", "bot"];
if (_mode isEqualTo "") then {_mode = "bot";};

private _className = missionNamespace getVariable ["mkk_ptg_targetSelection", ""];
if (_className isEqualTo "") exitWith {
    [localize "STR_MKK_PTG_TARGET_SELECT_FIRST"] call EFUNC(main,showTimedHint);
};

private _distance = parseNumber (uiNamespace getVariable ["mkk_ptg_targetDistance", "5"]);
private _patrolRadius = parseNumber (uiNamespace getVariable ["mkk_ptg_targetPatrol", "50"]);
private _airRadius = parseNumber (uiNamespace getVariable ["mkk_ptg_targetAirRadius", "150"]);
private _airHeight = parseNumber (uiNamespace getVariable ["mkk_ptg_targetAirHeight", "100"]);

[_mode, _className, player, _distance, _patrolRadius, _airRadius, _airHeight] call EFUNC(spawn,requestSpawnTarget);
