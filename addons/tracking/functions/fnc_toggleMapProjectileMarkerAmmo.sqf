#include "..\script_component.hpp"
/*
    Переключает подпись ammo classname у map marker.
*/
private _enabled = !(missionNamespace getVariable ["mkk_ptg_mapProjectileMarkerShowAmmo", false]);
missionNamespace setVariable ["mkk_ptg_mapProjectileMarkerShowAmmo", _enabled];

private _status = [localize "STR_MKK_PTG_DISABLED", localize "STR_MKK_PTG_ENABLED"] select _enabled;
hint format [localize "STR_MKK_PTG_MAP_MARKER_AMMO_STATUS", _status];
