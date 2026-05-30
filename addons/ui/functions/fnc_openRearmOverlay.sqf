#include "..\script_component.hpp"
/*
    Opens the browser rearm screen.
*/
disableSerialization;

private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if (isNull _display) exitWith {};

private _vehicle = objectParent player;
if (isNull _vehicle) exitWith {
    [localize "STR_MKK_PTG_REARM_ENTER_VEHICLE"] call EFUNC(main,showTimedHint);
};

[] call FUNC(closeTargetOverlay);
uiNamespace setVariable ["mkk_ptg_dashboardVisible", true];
uiNamespace setVariable ["mkk_ptg_rearmOverlayVisible", true];
[] call FUNC(refreshRearmOverlay);
[] call FUNC(setDashboardControlsBlocked);
