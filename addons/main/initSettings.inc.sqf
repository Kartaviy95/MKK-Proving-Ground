[
    "mkk_ptg_enable",
    "CHECKBOX",
    [localize "STR_MKK_PTG_SETTING_ENABLE_NAME", localize "STR_MKK_PTG_SETTING_ENABLE_DESC"],
    [localize "STR_MKK_PTG_MOD_NAME", localize "STR_MKK_PTG_CATEGORY_CORE"],
    true,
    1
] call CBA_fnc_addSetting;

[
    "mkk_ptg_allowAllUsers",
    "CHECKBOX",
    [localize "STR_MKK_PTG_SETTING_ALLOW_ALL_NAME", localize "STR_MKK_PTG_SETTING_ALLOW_ALL_DESC"],
    [localize "STR_MKK_PTG_MOD_NAME", localize "STR_MKK_PTG_CATEGORY_ACCESS"],
    true,
    1
] call CBA_fnc_addSetting;

[
    "mkk_ptg_trackingEnabled",
    "CHECKBOX",
    [localize "STR_MKK_PTG_SETTING_TRACKING_ENABLE_NAME", localize "STR_MKK_PTG_SETTING_TRACKING_ENABLE_DESC"],
    [localize "STR_MKK_PTG_MOD_NAME", localize "STR_MKK_PTG_CATEGORY_TRACKING"],
    true,
    1
] call CBA_fnc_addSetting;

[
    "mkk_ptg_trackingModeDefault",
    "LIST",
    [localize "STR_MKK_PTG_SETTING_TRACKING_MODE_NAME", localize "STR_MKK_PTG_SETTING_TRACKING_MODE_DESC"],
    [localize "STR_MKK_PTG_MOD_NAME", localize "STR_MKK_PTG_CATEGORY_TRACKING"],
    [["SIMPLE", "TACTICAL", "CINEMATIC"], ["Simple", "Tactical", "Cinematic"], 1],
    1
] call CBA_fnc_addSetting;

[
    "mkk_ptg_trackingMaxTime",
    "SLIDER",
    [localize "STR_MKK_PTG_SETTING_TRACKING_MAX_TIME_NAME", localize "STR_MKK_PTG_SETTING_TRACKING_MAX_TIME_DESC"],
    [localize "STR_MKK_PTG_MOD_NAME", localize "STR_MKK_PTG_CATEGORY_TRACKING"],
    [1, 20, 8, 0],
    1
] call CBA_fnc_addSetting;

[
    "mkk_ptg_trackingCooldown",
    "SLIDER",
    [localize "STR_MKK_PTG_SETTING_TRACKING_COOLDOWN_NAME", localize "STR_MKK_PTG_SETTING_TRACKING_COOLDOWN_DESC"],
    [localize "STR_MKK_PTG_MOD_NAME", localize "STR_MKK_PTG_CATEGORY_TRACKING"],
    [0, 10, 1, 1],
    1
] call CBA_fnc_addSetting;

[
    "mkk_ptg_spawnDefaultDistance",
    "SLIDER",
    [localize "STR_MKK_PTG_SETTING_SPAWN_DISTANCE_NAME", localize "STR_MKK_PTG_SETTING_SPAWN_DISTANCE_DESC"],
    [localize "STR_MKK_PTG_MOD_NAME", localize "STR_MKK_PTG_CATEGORY_SPAWN"],
    [5, 500, 30, 0],
    1
] call CBA_fnc_addSetting;

[
    "mkk_ptg_spawnMaxDistance",
    "SLIDER",
    [localize "STR_MKK_PTG_SETTING_SPAWN_MAX_DISTANCE_NAME", localize "STR_MKK_PTG_SETTING_SPAWN_MAX_DISTANCE_DESC"],
    [localize "STR_MKK_PTG_MOD_NAME", localize "STR_MKK_PTG_CATEGORY_SPAWN"],
    [10, 1000, 250, 0],
    1
] call CBA_fnc_addSetting;

[
    "mkk_ptg_maxVehicles",
    "SLIDER",
    [localize "STR_MKK_PTG_SETTING_MAX_VEHICLES_NAME", localize "STR_MKK_PTG_SETTING_MAX_VEHICLES_DESC"],
    [localize "STR_MKK_PTG_MOD_NAME", localize "STR_MKK_PTG_CATEGORY_SPAWN"],
    [1, 200, 50, 0],
    1
] call CBA_fnc_addSetting;

[
    "mkk_ptg_maxTargets",
    "SLIDER",
    [localize "STR_MKK_PTG_SETTING_MAX_TARGETS_NAME", localize "STR_MKK_PTG_SETTING_MAX_TARGETS_DESC"],
    [localize "STR_MKK_PTG_MOD_NAME", localize "STR_MKK_PTG_CATEGORY_TARGETS"],
    [1, 200, 50, 0],
    1
] call CBA_fnc_addSetting;

[
    "mkk_ptg_showDebugInfo",
    "CHECKBOX",
    [localize "STR_MKK_PTG_SETTING_DEBUG_NAME", localize "STR_MKK_PTG_SETTING_DEBUG_DESC"],
    [localize "STR_MKK_PTG_MOD_NAME", localize "STR_MKK_PTG_CATEGORY_DEBUG"],
    false,
    1
] call CBA_fnc_addSetting;
