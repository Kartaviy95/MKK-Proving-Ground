#include "..\script_component.hpp"
/*
    Показывает каталог и панель спавна техники.
*/
private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if (isNull _display) exitWith {};

uiNamespace setVariable ["mkk_ptg_dashboardVisible", false];

{
    (_display displayCtrl _x) ctrlShow false;
} forEach [
    88100, 88101, 88102, 88105, 88106, 88107, 88108, 88109, 88110, 88111, 88112, 88113, 88114, 88115, 88116, 88117, 88118, 88119, 88120, 88121, 88122, 88123, 88130, 88131, 88132, 88140, 88141, 88142, 88143, 88144, 88145, 88146, 88147, 88148, 88149, 88150, 88151
];

{
    (_display displayCtrl _x) ctrlShow true;
} forEach [
    88002, 88010, 88011, 88012, 88014, 88015, 88016, 88017, 88020, 88030, 88031,
    88040, 88041, 88044, 88045, 88046, 88047,
    88050, 88051, 88052, 88054, 88055, 88056, 88057
];

(_display displayCtrl 88003) ctrlSetText localize "STR_MKK_PTG_VEHICLE_SPAWN";
uiNamespace setVariable ["mkk_ptg_objectStatusSettingsVisible", false];
uiNamespace setVariable ["mkk_ptg_trajectorySettingsVisible", false];
uiNamespace setVariable ["mkk_ptg_mapProjectileMarkerSettingsVisible", false];
uiNamespace setVariable ["mkk_ptg_targetOverlayVisible", false];
[] call FUNC(updateObjectStatusSettingsMenu);
[] call FUNC(updateTrajectorySettingsMenu);
[] call FUNC(updateMapProjectileMarkerSettingsMenu);
[] call FUNC(setDashboardControlsBlocked);

[] call FUNC(refreshStaticAmmoBoxes);
