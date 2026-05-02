# MKK Proving Ground - architecture and localization

Use this when adding modules, moving code between addons, adding strings, or changing localization behavior.

23. Локализация

Основной файл локализации:

addons/main/stringtable.xml

Минимальные языки:

English;
Russian.

Правила:

в конфиге UI использовать text = "$STR_MKK_PTG_...";
в SQF использовать localize "STR_MKK_PTG_...";
не хранить пользовательский текст напрямую в action-строках;
для динамического текста использовать format [localize "...", ...];
для displayName из чужих модов использовать общий helper локализации;
если строка из чужого мода не локализуется, показывать безопасный fallback.

Текущее состояние stringtable:

ключи имеют префикс `STR_MKK_PTG_`;
в `addons/main/stringtable.xml` сейчас 161 key;
у всех текущих key есть English и Russian.

24. Внутренняя архитектура

Технические константы проекта:

project technical name: `mkk_ptg`;
build prefix: `ptg`;
`PREFIX` в коде: `ptg`;
версия из `script_version.hpp`: 1.0.0.0;
`REQUIRED_VERSION`: 2.20;
author: Tarantino.

Фактические модули проекта:

ptg_main;
ptg_common;
ptg_catalog;
ptg_ui;
ptg_spawn;
ptg_tracking;
ptg_penetration;
ptg_player;
ptg_player_ace;
ptg_ace.

Назначение модулей:

main — внутренняя конфигурация, keybind, открытие UI, виртуальный арсенал, удаление объекта под прицелом;
common — общие helpers, безопасное чтение конфигов, локализация строк;
catalog — сбор, фильтрация и описание техники, поиск совместимых ящиков БК для статики;
ui — диалог, стартовое меню, экран техники, обработчики кнопок, локальный статус-дисплей объектов при наведении;
spawn — серверный спавн и реестр созданных объектов;
tracking — слежение за projectile;
penetration — тест пробития техники, тестовый projectile, отчет damage/hitpoints/crew, preview техники, параметры CfgAmmo;
player — бесконечные патроны, режим бога, обработчики респавна и выстрелов;
player_ace — блокировка ACE medical damage для режима бога;
ace — ACE self actions и terminal actions.

Фактические зависимости:

`ptg_main` требует `cba_main`;
`ptg_common`, `ptg_catalog`, `ptg_spawn`, `ptg_tracking`, `ptg_player` требуют `ptg_main`;
`ptg_ui` требует `ptg_main` и `ptg_player`;
`ptg_penetration` требует `ptg_main`, `ptg_ui`, `ptg_catalog`, `ptg_spawn`, `ptg_tracking`;
`ptg_ace` требует `ptg_main` и `ace_interact_menu`;
`ptg_player_ace` требует `ptg_player` и `ace_medical_damage`, использует `skipWhenMissingDependencies = 1`.

Основные UI surfaces:

`MKK_PTG_MainDisplay` idd 88000;
`MKK_PTG_ObjectStatusDisplayHUD` RscTitles layer, idc 88200-88203;
`MKK_PTG_TrackingHUD` RscTitles layer, idc 88300-88302;
`MKK_PTG_PenetrationDisplay` idd 88900;
`MKK_PTG_PenetrationReportHUD` RscTitles layer, idc 88980-88981.

Серверные gameplay flows:

спавн техники: клиентский `ptg_spawn_fnc_requestSpawnVehicle` → server `ptg_spawn_fnc_serverSpawnVehicle`;
очистка полигона: UI → server `ptg_spawn_fnc_cleanupRange`;
удаление объекта под прицелом: client `ptg_main_fnc_deleteCursorObject` → server `ptg_main_fnc_serverDeleteObject`;
тестовая цель: UI/client wrapper `ptg_penetration_fnc_serverCreateTarget` → server same function;
тестовый projectile: client `ptg_penetration_fnc_createTestShot` или orbit click → server `ptg_penetration_fnc_serverFireTestShot`.
