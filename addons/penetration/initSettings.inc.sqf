[
    "mkk_ptg_penetrationTargetDistance",
    "SLIDER",
    [localize "STR_MKK_PTG_SETTING_PENETRATION_DISTANCE_NAME", localize "STR_MKK_PTG_SETTING_PENETRATION_DISTANCE_DESC"],
    [localize "STR_MKK_PTG_MOD_NAME", localize "STR_MKK_PTG_PENETRATION_TEST"],
    [50, 500, 120, 0],
    1
] call CBA_fnc_addSetting;

[
    "mkk_ptg_penetrationShotDistance",
    "SLIDER",
    [localize "STR_MKK_PTG_SETTING_PENETRATION_SHOT_DISTANCE_NAME", localize "STR_MKK_PTG_SETTING_PENETRATION_SHOT_DISTANCE_DESC"],
    [localize "STR_MKK_PTG_MOD_NAME", localize "STR_MKK_PTG_PENETRATION_TEST"],
    [20, 300, 70, 0],
    1
] call CBA_fnc_addSetting;
