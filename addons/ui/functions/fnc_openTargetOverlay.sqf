#include "..\script_component.hpp"
/*
    Opens the browser target screen.
*/
private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if (isNull _display) exitWith {};

[] call FUNC(closeRearmOverlay);
uiNamespace setVariable ["mkk_ptg_dashboardVisible", true];
uiNamespace setVariable ["mkk_ptg_targetOverlayVisible", true];
uiNamespace setVariable ["mkk_ptg_targetOverlayLastMode", ""];

if ((uiNamespace getVariable ["mkk_ptg_targetDistance", ""]) isEqualTo "") then {uiNamespace setVariable ["mkk_ptg_targetDistance", "5"];};
if ((uiNamespace getVariable ["mkk_ptg_targetPatrol", ""]) isEqualTo "") then {uiNamespace setVariable ["mkk_ptg_targetPatrol", "50"];};
if ((uiNamespace getVariable ["mkk_ptg_targetAirRadius", ""]) isEqualTo "") then {uiNamespace setVariable ["mkk_ptg_targetAirRadius", "150"];};
if ((uiNamespace getVariable ["mkk_ptg_targetAirHeight", ""]) isEqualTo "") then {uiNamespace setVariable ["mkk_ptg_targetAirHeight", "100"];};

[] call FUNC(refreshTargetList);
[] call FUNC(setDashboardControlsBlocked);
