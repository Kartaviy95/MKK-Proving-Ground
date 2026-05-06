#include "..\script_component.hpp"

/*
    Удаляет объект по запросу локального авторизованного игрока.
    Название оставлено для совместимости с PREP/вызовами, но функция больше не
    требует выполнения на сервере, чтобы dedicated server мог работать без аддона.
*/
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
