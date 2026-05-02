#include "..\script_component.hpp"

/*
    Запрашивает серверное удаление объекта, на который смотрит игрок.
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

[_entity, player] remoteExecCall [QFUNC(serverDeleteObject), 2];
[localize "STR_MKK_PTG_DELETE_CURSOR_OBJECT_DONE"] call FUNC(showTimedHint);
