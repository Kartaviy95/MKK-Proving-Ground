#include "..\script_component.hpp"
/*
    Closes the browser rearm screen and clears selection state.
*/
uiNamespace setVariable ["mkk_ptg_rearmOverlayVisible", false];
uiNamespace setVariable ["mkk_ptg_rearmVehicle", objNull];
uiNamespace setVariable ["mkk_ptg_rearmTurrets", []];
uiNamespace setVariable ["mkk_ptg_rearmSlotRows", []];
uiNamespace setVariable ["mkk_ptg_rearmWeaponRows", []];
uiNamespace setVariable ["mkk_ptg_rearmMagazineRows", []];
uiNamespace setVariable ["mkk_ptg_rearmSelectedTurret", []];
uiNamespace setVariable ["mkk_ptg_rearmSelectedWeapon", ""];
uiNamespace setVariable ["mkk_ptg_rearmSelectedMagazine", ""];
uiNamespace setVariable ["mkk_ptg_rearmCompatibleMagazines", []];
uiNamespace setVariable ["mkk_ptg_rearmSelectedMode", "turret"];
uiNamespace setVariable ["mkk_ptg_rearmSelectedPylon", -1];
uiNamespace setVariable ["mkk_ptg_rearmSelectedPylonTurret", []];
[] call FUNC(setDashboardControlsBlocked);
