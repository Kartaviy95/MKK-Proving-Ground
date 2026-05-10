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

[
    localize "STR_MKK_PTG_MOD_NAME",
    "mkk_ptg_close_map_camera",
    localize "STR_MKK_PTG_CLOSE_CAMERA",
    {
        if (missionNamespace getVariable ["mkk_ptg_mapCameraRunning", false]) exitWith {
            [] call ptg_ui_fnc_stopMapCamera;
            true
        };

        private _trackingState = missionNamespace getVariable ["mkk_ptg_trackingState", createHashMap];
        if (_trackingState isEqualType createHashMap && {count _trackingState > 0} && {!isNil "ptg_tracking_fnc_stopProjectileTrack"}) exitWith {
            [] call ptg_tracking_fnc_stopProjectileTrack;
            true
        };

        false
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
