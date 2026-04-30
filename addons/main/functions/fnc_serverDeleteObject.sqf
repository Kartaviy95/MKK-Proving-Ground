#include "..\script_component.hpp"

/*
    Удаляет объект на сервере по запросу локального игрока.
*/
if !(isServer) exitWith {};

params [
    ["_entity", objNull, [objNull]],
    ["_requestor", objNull, [objNull]]
];

if (isNull _entity || {isNull _requestor}) exitWith {};
if !([_requestor] call FUNC(isAuthorized)) exitWith {};
if (_entity isEqualTo _requestor) exitWith {};

private _crew = crew _entity;
if (isPlayer _entity || {_crew findIf {isPlayer _x} >= 0}) exitWith {};

{
    if (!isNull _x && {!isPlayer _x}) then {
        deleteVehicle _x;
    };
} forEach _crew;

deleteVehicle _entity;
