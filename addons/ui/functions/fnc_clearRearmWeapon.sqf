#include "..\script_component.hpp"
/*
    Removes compatible magazines from the selected vehicle turret weapon on the vehicle owner.
*/
params ["_vehicle", "_turret", "_magazines"];

if (isNull _vehicle) exitWith {};
if (!local _vehicle) exitWith {};

{
    _vehicle removeMagazinesTurret [_x, _turret];
} forEach (_magazines select {_x != ""});
