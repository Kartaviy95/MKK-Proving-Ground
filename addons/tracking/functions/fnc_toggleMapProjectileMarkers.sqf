#include "..\script_component.hpp"
/*
    Переключает маркеры projectile на карте.
*/
private _enabled = !(missionNamespace getVariable ["mkk_ptg_mapProjectileMarkersEnabled", false]);
missionNamespace setVariable ["mkk_ptg_mapProjectileMarkersEnabled", _enabled];

if (_enabled) then {
    [] call FUNC(registerTrackingEH);
};

private _status = [localize "STR_MKK_PTG_DISABLED", localize "STR_MKK_PTG_ENABLED"] select _enabled;
[format [localize "STR_MKK_PTG_MAP_MARKERS_STATUS", _status]] call EFUNC(main,showTimedHint);
