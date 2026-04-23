/*
    Регистрирует горячие клавиши через CBA.
*/
if (isNil "CBA_fnc_addKeybind") exitWith {
    ["CBA не найден. Горячие клавиши не зарегистрированы.", "WARN"] call mkk_ptg_fnc_log;
};

[
    "MKK PTG",
    "mkk_ptg_open_ui",
    "Открыть MKK Proving Ground",
    {
        [] call mkk_ptg_fnc_openMainUI;
    },
    {},
    [0x19, [false, true, false]]
] call CBA_fnc_addKeybind;
