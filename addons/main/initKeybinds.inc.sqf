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
    [0x16, [true, false, false]]
] call CBA_fnc_addKeybind;

[
    localize "STR_MKK_PTG_MOD_NAME",
    "mkk_ptg_open_ace_arsenal",
    localize "STR_MKK_PTG_OPEN_ACE_ARSENAL",
    {
        [] call FUNC(openAceArsenal);
    },
    {},
    [0x17, [true, false, false]]
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
    "mkk_ptg_unlock_cursor_vehicle",
    localize "STR_MKK_PTG_UNLOCK_CURSOR_VEHICLE",
    {
        [] call FUNC(unlockCursorVehicle);
        true
    },
    {},
    [DIK_F, [false, true, false]]
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

if !(isNil "CBA_fnc_hashGet" || {isNil "CBA_fnc_hashSet"}) then {
    private _registry = profileNamespace getVariable "cba_keybinding_registry_v3";
    if !(isNil "_registry") then {
        private _action = toLower format ["%1$%2", localize "STR_MKK_PTG_MOD_NAME", "mkk_ptg_close_map_camera"];
        private _storedKeybinds = [_registry, _action] call CBA_fnc_hashGet;
        if (_storedKeybinds isEqualTo [[DIK_ESCAPE, [false, false, false]]]) then {
            [_registry, _action, [[DIK_F, [false, false, false]]]] call CBA_fnc_hashSet;
            saveProfileNamespace;
        };
    };
};

[
    localize "STR_MKK_PTG_MOD_NAME",
    "mkk_ptg_close_map_camera",
    localize "STR_MKK_PTG_CLOSE_CAMERA",
    {
        [] call FUNC(closeActiveCamera)
    },
    {},
    [DIK_F, [false, false, false]]
] call CBA_fnc_addKeybind;

[
    localize "STR_MKK_PTG_MOD_NAME",
    "mkk_ptg_start_teleport",
    localize "STR_MKK_PTG_TELEPORT",
    {
        if !(isNil "ptg_ui_fnc_startTeleport") exitWith {
            [] call ptg_ui_fnc_startTeleport;
            true
        };
        false
    },
    {},
    [DIK_T, [false, false, false]]
] call CBA_fnc_addKeybind;
