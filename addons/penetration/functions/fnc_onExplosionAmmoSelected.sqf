#include "..\script_component.hpp"
/*
    Handles explosion ammo selection.
*/
params ["_ctrl", "_idx"];

private _ammoClass = _ctrl lbData _idx;
if (_ammoClass isEqualTo "") exitWith {
    missionNamespace setVariable ["mkk_ptg_explosionAmmoClass", ""];
    [] call FUNC(updateExplosionAmmoInfo);
};

missionNamespace setVariable ["mkk_ptg_explosionAmmoClass", _ammoClass];
[] call FUNC(updateExplosionAmmoInfo);
