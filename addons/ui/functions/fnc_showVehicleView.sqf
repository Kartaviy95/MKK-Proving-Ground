#include "..\script_component.hpp"
/*
    Shows the vehicle catalog screen in the browser UI.
*/
private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if (isNull _display) exitWith {};

uiNamespace setVariable ["mkk_ptg_dashboardVisible", false];
uiNamespace setVariable ["mkk_ptg_targetOverlayVisible", false];
uiNamespace setVariable ["mkk_ptg_objectStatusSettingsVisible", false];
uiNamespace setVariable ["mkk_ptg_trajectorySettingsVisible", false];
uiNamespace setVariable ["mkk_ptg_mapProjectileMarkerSettingsVisible", false];
uiNamespace setVariable ["mkk_ptg_hitpointInspectorSettingsVisible", false];

[] call FUNC(closeRearmOverlay);
[] call FUNC(setDashboardControlsBlocked);

if !(uiNamespace getVariable ["mkk_ptg_vehicleFiltersReady", false]) then {
    [] call FUNC(refreshFilters);
    uiNamespace setVariable ["mkk_ptg_vehicleFiltersReady", true];
} else {
    [] call FUNC(refreshVehicleList);
};
