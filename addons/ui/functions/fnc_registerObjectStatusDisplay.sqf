#include "..\script_component.hpp"
/*
    Registers the local Draw3D updater for object status display.
*/
if !(hasInterface) exitWith {};
if (missionNamespace getVariable ["mkk_ptg_objectStatusDisplayDrawEHAdded", false]) exitWith {};

addMissionEventHandler ["Draw3D", {
    [] call FUNC(drawObjectStatusDisplay);
}];

missionNamespace setVariable ["mkk_ptg_objectStatusDisplayDrawEHAdded", true];
