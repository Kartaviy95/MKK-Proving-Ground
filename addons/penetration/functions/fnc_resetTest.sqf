#include "..\script_component.hpp"
/*
    Сбрасывает текущую тестовую цель.
*/
[] call FUNC(stopOrbitCamera);

private _target = missionNamespace getVariable ["mkk_ptg_penetrationTarget", objNull];
private _className = missionNamespace getVariable ["mkk_ptg_penetrationTargetClass", ""];
if (_className isNotEqualTo "") then {
    [_className, player, true] call FUNC(serverCreateTarget);
} else {
    if (!isNull _target && {[_target] call EFUNC(main,isPTGCreatedEntity)}) then {
        {
            if (!isNull _x && {!isPlayer _x} && {[_x] call EFUNC(main,isPTGCreatedEntity)}) then {
                deleteVehicle _x;
            };
        } forEach crew _target;

        deleteVehicle _target;
    };
};

missionNamespace setVariable ["mkk_ptg_penetrationReport", ""];
[] call FUNC(updateReport);
