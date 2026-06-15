#include "..\script_component.hpp"
/*
    Чинит общий урон и hitpoints техники на машине, где техника локальна.
*/
params [
    ["_vehicle", objNull, [objNull]],
    ["_routed", false, [false]]
];

if (isNull _vehicle) exitWith {};

if (!_routed && {!local _vehicle}) exitWith {
    [_vehicle, true] remoteExecCall [QFUNC(repairVehicleDamage), _vehicle];
};

_vehicle setDamage 0;

private _hitpoints = getAllHitPointsDamage _vehicle;
private _names = _hitpoints param [0, []];

{
    if (_x isNotEqualTo "") then {
        _vehicle setHitPointDamage [_x, 0, false];
    };
} forEach _names;

_vehicle setDamage 0;
