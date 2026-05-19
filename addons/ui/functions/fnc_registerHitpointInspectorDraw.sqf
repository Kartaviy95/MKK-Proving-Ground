#include "..\script_component.hpp"
/*
    Регистрирует локальный Draw3D handler для объемов hitpoints в инспекторе.
*/
if !(hasInterface) exitWith {};
if (missionNamespace getVariable ["mkk_ptg_hitpointInspectorDrawEHAdded", false]) exitWith {};

addMissionEventHandler ["Draw3D", {
    [] call FUNC(drawHitpointInspectorVolumes);
}];

missionNamespace setVariable ["mkk_ptg_hitpointInspectorDrawEHAdded", true];
