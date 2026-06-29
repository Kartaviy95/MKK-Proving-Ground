#include "script_component.hpp"

if (hasInterface) then {
    private _mapEH = addMissionEventHandler ["Map", {
        params ["_mapIsOpened"];

        if !(_mapIsOpened) exitWith {
            [] call ptg_penetration_fnc_detachExplosionMarkerMapHandlers;
        };

        [] spawn {
            waitUntil {
                uiSleep 0.01;
                !isNull (findDisplay 12) || {!isNull (findDisplay 52)} || {!visibleMap}
            };

            if !(visibleMap) exitWith {};
            [] call ptg_penetration_fnc_attachExplosionMarkerMapHandlers;
        };
    }];

    missionNamespace setVariable ["mkk_ptg_explosionMarkerMapMissionEH", _mapEH];

    if (!isNull (findDisplay 12) || {!isNull (findDisplay 52)}) then {
        [] call FUNC(attachExplosionMarkerMapHandlers);
    };
};
