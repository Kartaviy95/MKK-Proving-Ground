#include "..\script_component.hpp"

/*
    Удаляет объект, на который смотрит игрок.
    Не отправляем запрос на dedicated server: сервер может быть запущен без аддона.
    deleteVehicle имеет глобальный эффект в MP, поэтому удаление, выполненное клиентом,
    синхронизируется для остальных машин.
*/
if !(hasInterface) exitWith {};
if !([player] call FUNC(isAuthorized)) exitWith {
    [localize "STR_MKK_PTG_NO_ACCESS"] call FUNC(showTimedHint);
};

private _entity = cursorObject;
if (isNull _entity) then {
    _entity = cursorTarget;
};

if (isNull _entity || {_entity isEqualTo player}) exitWith {
    [localize "STR_MKK_PTG_DELETE_CURSOR_OBJECT_NONE"] call FUNC(showTimedHint);
};

if (isPlayer _entity || {(crew _entity) findIf {isPlayer _x} >= 0}) exitWith {
    [localize "STR_MKK_PTG_DELETE_CURSOR_OBJECT_PLAYER"] call FUNC(showTimedHint);
};

[_entity, player] call FUNC(serverDeleteObject);
[localize "STR_MKK_PTG_DELETE_CURSOR_OBJECT_DONE"] call FUNC(showTimedHint);
