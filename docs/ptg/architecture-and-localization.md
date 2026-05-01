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

24. Внутренняя архитектура

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

