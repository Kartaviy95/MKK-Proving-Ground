#include "script_component.hpp"

if (hasInterface) then {
    [false] call FUNC(startMapHeightProbe);

    private _mapEH = addMissionEventHandler ["Map", {
        params ["_mapIsOpened"];

        if !(_mapIsOpened) exitWith {
            [] call ptg_ui_fnc_detachMapSmokeHandlers;
        };

        [] spawn {
            waitUntil {
                uiSleep 0.01;
                !isNull (findDisplay 12) || {!isNull (findDisplay 52)}
            };

            [] call ptg_ui_fnc_attachMapSmokeHandlers;
        };
    }];

    missionNamespace setVariable ["mkk_ptg_mapSmokeMapMissionEH", _mapEH];

    if (!isNull (findDisplay 12) || {!isNull (findDisplay 52)}) then {
        [] call FUNC(attachMapSmokeHandlers);
    };
};
