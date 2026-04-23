/*
    Добавляет ACE self-action для открытия полигона.
*/
if !(hasInterface) exitWith {};
if (isNil "ace_interact_menu_fnc_createAction") exitWith {};

private _action = [
    "mkk_ptg_open_ui",
    "Open Proving Ground",
    "",
    {
        [] call mkk_ptg_fnc_openMainUI;
    },
    {
        [player] call mkk_ptg_fnc_isAuthorized
    }
] call ace_interact_menu_fnc_createAction;

["CAManBase", 1, ["ACE_SelfActions"], _action, true] call ace_interact_menu_fnc_addActionToClass;
