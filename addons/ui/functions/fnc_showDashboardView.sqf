#include "..\script_component.hpp"
/*
    Показывает стартовую панель функций.
*/
private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if (isNull _display) exitWith {};

uiNamespace setVariable ["mkk_ptg_dashboardVisible", true];

{
    (_display displayCtrl _x) ctrlShow false;
} forEach [
    88002, 88010, 88011, 88012, 88014, 88015, 88016, 88017, 88020, 88030, 88031,
    88040, 88041, 88044, 88045, 88046, 88047,
    88050, 88051, 88052, 88054, 88055, 88056, 88057,
    88112,
    88200, 88201, 88202, 88203, 88204, 88205, 88206, 88207, 88220, 88221, 88222, 88230, 88231, 88240, 88241, 88242,
    88300, 88301, 88302, 88303, 88304, 88305, 88306, 88307, 88308, 88309, 88310, 88311, 88315, 88316, 88317, 88318, 88320, 88330, 88331, 88340, 88341, 88342
];

{
    (_display displayCtrl _x) ctrlShow true;
} forEach [88100, 88101, 88102, 88105, 88106, 88107, 88108, 88109, 88110, 88111, 88113, 88114, 88115, 88116, 88117, 88118, 88119, 88120, 88121, 88122, 88130, 88131, 88132, 88140, 88141, 88142, 88143, 88144, 88145, 88146, 88147, 88148, 88149, 88150];

(_display displayCtrl 88003) ctrlSetText localize "STR_MKK_PTG_SELECT_FUNCTION";
uiNamespace setVariable ["mkk_ptg_objectStatusSettingsVisible", false];
uiNamespace setVariable ["mkk_ptg_trajectorySettingsVisible", false];
uiNamespace setVariable ["mkk_ptg_mapProjectileMarkerSettingsVisible", false];
uiNamespace setVariable ["mkk_ptg_targetOverlayVisible", false];
[] call FUNC(updateObjectStatusSettingsMenu);
[] call FUNC(updateTrajectorySettingsMenu);
[] call FUNC(updateMapProjectileMarkerSettingsMenu);
[] call FUNC(closeRearmOverlay);
[] call FUNC(setDashboardControlsBlocked);
