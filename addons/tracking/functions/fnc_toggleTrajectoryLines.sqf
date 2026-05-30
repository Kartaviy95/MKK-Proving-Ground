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
