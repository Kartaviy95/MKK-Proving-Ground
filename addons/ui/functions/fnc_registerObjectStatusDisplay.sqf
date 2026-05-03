#include "..\script_component.hpp"
/*
    Регистрирует локальный Draw3D updater для статус-дисплея объектов.
*/
if !(hasInterface) exitWith {};
if (missionNamespace getVariable ["mkk_ptg_objectStatusDisplayDrawEHAdded", false]) exitWith {};

addMissionEventHandler ["Draw3D", {
    [] call FUNC(drawObjectStatusDisplay);
}];

missionNamespace setVariable ["mkk_ptg_objectStatusDisplayDrawEHAdded", true];
