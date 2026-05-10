#include "..\script_component.hpp"
/*
    Отправляет запрос на создание выбранной цели.
*/
private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if (isNull _display) exitWith {};

private _ctrlMode = _display displayCtrl 88310;
private _mode = _ctrlMode lbData (lbCurSel _ctrlMode);
if (_mode isEqualTo "") then {_mode = "bot";};

private _className = missionNamespace getVariable ["mkk_ptg_targetSelection", ""];
if (_className isEqualTo "") exitWith {
    [localize "STR_MKK_PTG_TARGET_SELECT_FIRST"] call EFUNC(main,showTimedHint);
};

private _distance = parseNumber ctrlText (_display displayCtrl 88315);
private _patrolRadius = parseNumber ctrlText (_display displayCtrl 88316);
private _airRadius = parseNumber ctrlText (_display displayCtrl 88317);
private _airHeight = parseNumber ctrlText (_display displayCtrl 88318);

[_mode, _className, player, _distance, _patrolRadius, _airRadius, _airHeight] call EFUNC(spawn,requestSpawnTarget);
