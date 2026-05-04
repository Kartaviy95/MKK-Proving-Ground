#include "..\script_component.hpp"
/*
    Возвращает unit-владельца выбранной турели, если он есть.
    Важно для MP: боекомплект турели часто актуален на клиенте стрелка, а не на владельце vehicle.
    Если турель пустая, возвращает objNull — тогда операцию выполняет клиент, который нажал кнопку,
    как в proving_ground, без зависимости от серверного аддона.
*/
params ["_vehicle", ["_turret", []]];

if (isNull _vehicle) exitWith {objNull};
if !(_turret isEqualType []) exitWith {objNull};

private _unit = _vehicle turretUnit _turret;
if (isNull _unit) exitWith {objNull};

_unit
