#include "..\script_component.hpp"
/*
    Переключает отображение линий траектории projectile.
*/
private _enabled = !(missionNamespace getVariable ["mkk_ptg_trajectoryEnabled", false]);
missionNamespace setVariable ["mkk_ptg_trajectoryEnabled", _enabled];

if (_enabled) then {
    [] call FUNC(registerTrackingEH);
    [] call FUNC(registerTrajectoryDraw);
};

if !(_enabled) then {
    missionNamespace setVariable ["mkk_ptg_trajectoryLines", []];
};

private _status = [localize "STR_MKK_PTG_DISABLED", localize "STR_MKK_PTG_ENABLED"] select _enabled;
[format [localize "STR_MKK_PTG_TRAJECTORY_STATUS", _status]] call EFUNC(main,showTimedHint);
