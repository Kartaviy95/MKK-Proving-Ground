#include "..\script_component.hpp"
/*
    Скрывает controls dashboard, пока открыт popup настроек.
*/
disableSerialization;

private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if (isNull _display) exitWith {};

private _dashboardVisible = uiNamespace getVariable ["mkk_ptg_dashboardVisible", false];
private _blocked = (uiNamespace getVariable ["mkk_ptg_objectStatusSettingsVisible", false])
    || {uiNamespace getVariable ["mkk_ptg_trajectorySettingsVisible", false]}
    || {uiNamespace getVariable ["mkk_ptg_mapProjectileMarkerSettingsVisible", false]}
    || {uiNamespace getVariable ["mkk_ptg_targetOverlayVisible", false]}
    || {uiNamespace getVariable ["mkk_ptg_rearmOverlayVisible", false]};

{
    private _ctrl = _display displayCtrl _x;
    if (!isNull _ctrl) then {
        _ctrl ctrlShow (_dashboardVisible && {!_blocked});
    };
} forEach [88100, 88101, 88102, 88105, 88106, 88107, 88108, 88109, 88110, 88111, 88113, 88114, 88115, 88116, 88117, 88118, 88119, 88120, 88121, 88122, 88123, 88130, 88131, 88132, 88140, 88141, 88142, 88143, 88144, 88145, 88146, 88147, 88148, 88149, 88150, 88151];


private _rearmButton = _display displayCtrl 88121;
if (!isNull _rearmButton) then {
    _rearmButton ctrlEnable !(isNull objectParent player);
};

private _ammoClassButton = _display displayCtrl 88112;
if (!isNull _ammoClassButton) then {
    _ammoClassButton ctrlShow false;
};
