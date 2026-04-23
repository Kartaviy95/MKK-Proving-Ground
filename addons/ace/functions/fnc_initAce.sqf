#include "..\script_component.hpp"
/*
    Инициализация ACE-интеграции.
*/
if !(hasInterface) exitWith {};
if (isNil "ace_interact_menu_fnc_createAction") exitWith {};

[] call FUNC(addSelfActions);
[] call FUNC(addTerminalActions);
