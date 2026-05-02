#include "..\script_component.hpp"
/*
    Переключает локальную систему слежения за projectile.
*/
private _enabled = !(missionNamespace getVariable ["mkk_ptg_trackingEnabled", false]);
missionNamespace setVariable ["mkk_ptg_trackingEnabled", _enabled];

if (_enabled) then {
    [] call EFUNC(tracking,registerTrackingEH);
};

private _status = [localize "STR_MKK_PTG_DISABLED", localize "STR_MKK_PTG_ENABLED"] select _enabled;
[format [localize "STR_MKK_PTG_TRACKING_STATUS", _status]] call EFUNC(main,showTimedHint);
