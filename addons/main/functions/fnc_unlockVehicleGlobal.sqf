#include "..\script_component.hpp"

/*
    Unlocks a vehicle and removes the engine lock EH on every machine.
*/
params [
    ["_vehicle", objNull, [objNull]]
];

if (isNull _vehicle) exitWith {};

_vehicle lock false;
_vehicle setVehicleLock "UNLOCKED";

private _engineEh = _vehicle getVariable ["engineeh", -1];
if (_engineEh isEqualType 0 && {_engineEh >= 0}) then {
    _vehicle removeEventHandler ["Engine", _engineEh];
    _vehicle setVariable ["engineeh", -1, true];
};
