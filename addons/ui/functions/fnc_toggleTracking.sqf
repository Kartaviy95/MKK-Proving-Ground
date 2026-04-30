#include "..\script_component.hpp"
/*
    Переключает локальную систему слежения за projectile.
*/
private _enabled = !(missionNamespace getVariable ["mkk_ptg_trackingEnabled", true]);
missionNamespace setVariable ["mkk_ptg_trackingEnabled", _enabled];

private _status = [localize "STR_MKK_PTG_DISABLED", localize "STR_MKK_PTG_ENABLED"] select _enabled;
hint format [localize "STR_MKK_PTG_TRACKING_STATUS", _status];
