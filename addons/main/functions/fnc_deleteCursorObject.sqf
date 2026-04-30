#include "..\script_component.hpp"

/*
    Запрашивает серверное удаление объекта, на который смотрит игрок.
*/
if !(hasInterface) exitWith {};
if !([player] call FUNC(isAuthorized)) exitWith {
    hint localize "STR_MKK_PTG_NO_ACCESS";
};

private _entity = cursorObject;
if (isNull _entity) then {
    _entity = cursorTarget;
};

if (isNull _entity || {_entity isEqualTo player}) exitWith {
    hint localize "STR_MKK_PTG_DELETE_CURSOR_OBJECT_NONE";
};

if (isPlayer _entity || {(crew _entity) findIf {isPlayer _x} >= 0}) exitWith {
    hint localize "STR_MKK_PTG_DELETE_CURSOR_OBJECT_PLAYER";
};

[_entity, player] remoteExecCall [QFUNC(serverDeleteObject), 2];
hint localize "STR_MKK_PTG_DELETE_CURSOR_OBJECT_DONE";
