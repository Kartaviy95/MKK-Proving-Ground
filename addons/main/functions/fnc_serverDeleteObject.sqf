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

if (isNull _entity || {isNull _requestor}) exitWith {false};
if !([_requestor] call FUNC(isAuthorized)) exitWith {false};
if (_entity isEqualTo _requestor) exitWith {false};
if !([_entity] call FUNC(isPTGCreatedEntity)) exitWith {false};

private _crew = crew _entity;
if (isPlayer _entity || {_crew findIf {isPlayer _x} >= 0}) exitWith {false};

{
    if (!isNull _x && {!isPlayer _x} && {[_x] call FUNC(isPTGCreatedEntity)}) then {
        deleteVehicle _x;
    };
} forEach _crew;

deleteVehicle _entity;
true
