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

[
    localize "STR_MKK_PTG_MOD_NAME",
    "mkk_ptg_open_virtual_arsenal",
    localize "STR_MKK_PTG_OPEN_VIRTUAL_ARSENAL",
    {
        [] call FUNC(openVirtualArsenal);
    },
    {},
    [0xC7, [true, false, false]]
] call CBA_fnc_addKeybind;

[
    localize "STR_MKK_PTG_MOD_NAME",
    "mkk_ptg_copy_cursor_object_class",
    localize "STR_MKK_PTG_COPY_CURSOR_OBJECT_CLASS",
    {
        [] call FUNC(copyCursorObjectClass);
        true
    },
    {},
    [DIK_C, [false, true, false]]
] call CBA_fnc_addKeybind;

[
    localize "STR_MKK_PTG_MOD_NAME",
    "mkk_ptg_delete_cursor_object",
    localize "STR_MKK_PTG_DELETE_CURSOR_OBJECT",
    {
        [] call FUNC(deleteCursorObject);
        true
    },
    {},
    [DIK_DELETE, [false, false, false]]
] call CBA_fnc_addKeybind;
