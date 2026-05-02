#include "..\script_component.hpp"

/*
    Копирует classname объекта, на который смотрит игрок.
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
    [localize "STR_MKK_PTG_COPY_CURSOR_OBJECT_CLASS_NONE"] call FUNC(showTimedHint);
};

private _className = typeOf _entity;
if (_className isEqualTo "") exitWith {
    [localize "STR_MKK_PTG_INFO_NOT_FOUND"] call FUNC(showTimedHint);
};

copyToClipboard _className;
[format [localize "STR_MKK_PTG_CLASS_COPIED", _className]] call FUNC(showTimedHint);
