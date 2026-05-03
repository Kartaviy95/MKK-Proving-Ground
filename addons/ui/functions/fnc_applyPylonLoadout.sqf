#include "..\script_component.hpp"
/*
    Применяет loadout пилона на машине, где техника local.
*/
params ["_vehicle", "_pylonIndex", ["_magazine", ""], ["_turretPath", []]];

if (isNull _vehicle) exitWith {};
if (!local _vehicle) exitWith {
    _this remoteExecCall [QFUNC(applyPylonLoadout), _vehicle];
};

_vehicle setPylonLoadout [_pylonIndex, _magazine, true, _turretPath];
