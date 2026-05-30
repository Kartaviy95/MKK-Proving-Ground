#include "..\script_component.hpp"
/*
    Shows the browser dashboard.
*/
if !(uiNamespace getVariable ["mkk_ptg_dashboardVisible", true]) then {
    [false] call FUNC(saveVehicleSpawnState);
};

uiNamespace setVariable ["mkk_ptg_dashboardVisible", true];
uiNamespace setVariable ["mkk_ptg_targetOverlayVisible", false];
uiNamespace setVariable ["mkk_ptg_objectStatusSettingsVisible", false];
uiNamespace setVariable ["mkk_ptg_trajectorySettingsVisible", false];
uiNamespace setVariable ["mkk_ptg_mapProjectileMarkerSettingsVisible", false];
uiNamespace setVariable ["mkk_ptg_hitpointInspectorSettingsVisible", false];

[] call FUNC(closeRearmOverlay);
[] call FUNC(updateDashboardKeybindLabels);
[] call FUNC(initInterfaceSizeCombo);
[] call FUNC(setDashboardControlsBlocked);
