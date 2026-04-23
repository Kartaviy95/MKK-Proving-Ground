/*
    Регистрирует настройки через CBA.
*/
if (isNil "CBA_fnc_addSetting") exitWith {
    ["CBA не найден. Настройки не зарегистрированы.", "WARN"] call mkk_ptg_fnc_log;
};

[
    "mkk_ptg_enable",
    "CHECKBOX",
    ["Включить MKK PTG", "Главный переключатель системы полигона."],
    ["MKK PTG", "Core"],
    true,
    1
] call CBA_fnc_addSetting;

[
    "mkk_ptg_allowAllUsers",
    "CHECKBOX",
    ["Разрешить всем", "Если включено, полигон доступен всем игрокам."],
    ["MKK PTG", "Access"],
    true,
    1
] call CBA_fnc_addSetting;

[
    "mkk_ptg_trackingEnabled",
    "CHECKBOX",
    ["Включить tracking", "Разрешает локальную систему слежки за projectile."],
    ["MKK PTG", "Tracking"],
    true,
    1
] call CBA_fnc_addSetting;

[
    "mkk_ptg_trackingModeDefault",
    "LIST",
    ["Режим tracking", "Режим tracking по умолчанию."],
    ["MKK PTG", "Tracking"],
    [["SIMPLE", "TACTICAL", "CINEMATIC"], ["Simple", "Tactical", "Cinematic"], 1],
    1
] call CBA_fnc_addSetting;

[
    "mkk_ptg_trackingMaxTime",
    "SLIDER",
    ["Максимум времени tracking", "Максимальная длительность слежки в секундах."],
    ["MKK PTG", "Tracking"],
    [1, 20, 8, 0],
    1
] call CBA_fnc_addSetting;

[
    "mkk_ptg_trackingCooldown",
    "SLIDER",
    ["Кулдаун tracking", "Задержка между автозапусками слежки."],
    ["MKK PTG", "Tracking"],
    [0, 10, 1, 1],
    1
] call CBA_fnc_addSetting;

[
    "mkk_ptg_spawnDefaultDistance",
    "SLIDER",
    ["Дистанция спавна", "Базовая дистанция спавна техники от игрока."],
    ["MKK PTG", "Spawn"],
    [5, 500, 30, 0],
    1
] call CBA_fnc_addSetting;

[
    "mkk_ptg_spawnMaxDistance",
    "SLIDER",
    ["Лимит дистанции", "Максимально допустимая дистанция спавна."],
    ["MKK PTG", "Spawn"],
    [10, 1000, 250, 0],
    1
] call CBA_fnc_addSetting;

[
    "mkk_ptg_maxVehicles",
    "SLIDER",
    ["Лимит техники", "Максимальное количество техники полигона."],
    ["MKK PTG", "Spawn"],
    [1, 200, 50, 0],
    1
] call CBA_fnc_addSetting;

[
    "mkk_ptg_maxTargets",
    "SLIDER",
    ["Лимит мишеней", "Максимальное количество целей полигона."],
    ["MKK PTG", "Targets"],
    [1, 200, 50, 0],
    1
] call CBA_fnc_addSetting;

[
    "mkk_ptg_showDebugInfo",
    "CHECKBOX",
    ["Показывать debug", "Включает служебную отладочную информацию."],
    ["MKK PTG", "Debug"],
    false,
    1
] call CBA_fnc_addSetting;
