/*
    Инициализация ACE-интеграции.
*/
if !(hasInterface) exitWith {};
if (isNil "ace_interact_menu_fnc_createAction") exitWith {};

[] call mkk_ptg_fnc_addSelfActions;
[] call mkk_ptg_fnc_addTerminalActions;
