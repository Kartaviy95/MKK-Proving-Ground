#include "..\script_component.hpp"
/*
    Переключает локальную систему слежения за projectile.
*/
private _enabled = !(missionNamespace getVariable ["mkk_ptg_trackingEnabled", false]);
missionNamespace setVariable ["mkk_ptg_trackingEnabled", _enabled];

if (_enabled) then {
    [] call EFUNC(tracking,registerTrackingEH);
};
