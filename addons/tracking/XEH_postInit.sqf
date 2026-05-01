#include "script_component.hpp"

if !(hasInterface) exitWith {};

[] spawn {
    waitUntil {
        sleep 0.1;
        !isNull player
    };

    [] call FUNC(registerTrajectoryDraw);

    [{
        [] call FUNC(registerTrackingEH);
    }, 1] call CBA_fnc_addPerFrameHandler;
};
