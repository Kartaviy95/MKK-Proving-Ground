#include "..\script_component.hpp"
/*
    Starts or stops local map timing with the stored player settings.
*/
if !(hasInterface) exitWith {false};

params [
    ["_color", "", [""]]
];

if (missionNamespace getVariable ["mkk_ptg_mapTimingActive", false]) exitWith {
    [] call FUNC(stopMapTiming);
    true
};

[_color] call FUNC(startMapTiming);
true
