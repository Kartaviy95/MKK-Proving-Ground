#include "..\script_component.hpp"
/*
    Удаляет все цели, созданные через меню целей.
*/
{
    if !(isNull _x) then {
        if (_x isKindOf "Man") then {
            deleteVehicle _x;
        } else {
            {deleteVehicle _x;} forEach crew _x;
            deleteVehicle _x;
        };
    };
} forEach (missionNamespace getVariable ["mkk_ptg_spawnedTargets", []]);

missionNamespace setVariable ["mkk_ptg_spawnedTargets", [], true];
