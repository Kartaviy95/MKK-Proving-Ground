[
    localize "STR_MKK_PTG_MOD_NAME",
    "mkk_ptg_open_ui",
    localize "STR_MKK_PTG_OPEN",
    {
        [] call FUNC(openMainUI);
    },
    {},
    [0xC7, [false, false, false]]
] call CBA_fnc_addKeybind;
