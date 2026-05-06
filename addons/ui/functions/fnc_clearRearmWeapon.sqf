#include "..\script_component.hpp"
/*
    Удаляет совместимые магазины из выбранного оружия турели.
    Выполняется на клиенте стрелка выбранной турели, если он есть.
*/
params ["_vehicle", "_turret", "_magazines"];

if (isNull _vehicle) exitWith {};

{
    _vehicle removeMagazinesTurret [_x, _turret];
} forEach (_magazines select {_x != ""});
