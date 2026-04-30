#include "..\script_component.hpp"
/*
    Сбрасывает текущую тестовую цель.
*/
[] call FUNC(stopOrbitCamera);

private _target = missionNamespace getVariable ["mkk_ptg_penetrationTarget", objNull];
private _className = missionNamespace getVariable ["mkk_ptg_penetrationTargetClass", ""];
if (_className != "") then {
    [_className, player, true] remoteExecCall [QFUNC(serverCreateTarget), 2];
} else {
    if !(isNull _target) then {
        deleteVehicle _target;
    };
};

missionNamespace setVariable ["mkk_ptg_penetrationReport", ""];
[] call FUNC(updateReport);
