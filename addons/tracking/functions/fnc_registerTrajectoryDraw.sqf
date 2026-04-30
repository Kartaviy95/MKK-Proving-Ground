#include "..\script_component.hpp"
/*
    Регистрирует Draw3D для отображения линий траектории.
*/
if !(hasInterface) exitWith {};
if (missionNamespace getVariable ["mkk_ptg_trajectoryDrawEHAdded", false]) exitWith {};

addMissionEventHandler ["Draw3D", {
    [] call FUNC(drawTrajectoryLines);
}];

missionNamespace setVariable ["mkk_ptg_trajectoryDrawEHAdded", true];
