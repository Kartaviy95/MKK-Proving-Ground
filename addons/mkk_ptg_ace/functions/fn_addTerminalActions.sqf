/*
    Добавляет ACE action на базовые терминалы.
*/
if !(hasInterface) exitWith {};
if (isNil "ace_interact_menu_fnc_createAction") exitWith {};

private _action = [
    "mkk_ptg_open_terminal",
    "Open Proving Ground",
    "",
    {
        [] call mkk_ptg_fnc_openMainUI;
    },
    {
        [player] call mkk_ptg_fnc_isAuthorized
    }
] call ace_interact_menu_fnc_createAction;

{
    [_x, 0, ["ACE_MainActions"], _action, true] call ace_interact_menu_fnc_addActionToClass;
} forEach [
    "Land_Laptop_unfolded_F",
    "Land_Laptop_device_F",
    "Land_Tablet_02_F"
];
