# AGENTS.md — руководство для Codex по MKK Proving Ground

## Главное правило экономии токенов

Держать этот файл коротким и сначала читать только документы, относящиеся к задаче. Не открывать весь `docs/ptg/` и особенно `docs/ptg/design-full.md` по умолчанию.

## Актуальный технический снимок

- Проект: MKK Proving Ground.
- Техническое имя: `mkk_ptg`.
- Префикс сборки: `ptg`.
- Текущая версия из `addons/main/script_version.hpp`: `1.3.5.0`.
- Минимальная версия Arma 3 из `REQUIRED_VERSION`: `2.20`.
- Базовая зависимость: `CBA_A3` / `cba_main`.
- Optional ACE-зависимости: `ptg_ace` через `ace_interact_menu`, `ptg_player_ace` через `ace_medical_damage`; оба используют `skipWhenMissingDependencies = 1`.
- Локализация: `addons/main/stringtable.xml`, 306 ключей `STR_MKK_PTG_*`, у текущих ключей есть `English`, `Russian`, `German`.
- Назначение: модульный полигон Arma 3 для проверки техники, вооружения, projectile, траекторий, пробития, взрывных боеприпасов по карте, телепортации, камеры, перевооружения и локальных утилит игрока.

## Рабочие правила по умолчанию

- Предпочитать минимальный diff и не форматировать несвязанные файлы.
- Работать только с файлами, относящимися к задаче.
- Не делать проверку через Git и HEMTT.
- Не хардкодить модовые фракции, технику, боеприпасы или UI-строки.
- Видимый пользователю текст добавлять только через `addons/main/stringtable.xml` с `English`, `Russian`, `German`.
- При расхождении README модулей, `docs/ptg/*.md` и кода — приоритет у текущего кода, затем у профильного документа из `docs/ptg/`.
- Клиентские UI, камеры, HUD, browser/web-state и draw-обработчики держать за `hasInterface`.
- Создание, удаление и очистку игровых объектов проводить через существующие request/server-named потоки проекта; UI-кнопки не должны напрямую создавать игровые объекты.
- Не открывать широкий remote execution без необходимости. Для object-local действий использовать существующий поток проекта или remoteExec на владельца объекта.
- Для отсутствующих config-значений, изображений и неразрешенных локализованных имен использовать безопасные резервные варианты.
- В SQF избегать `if !(x isEqualTo y)`; использовать прямые формы вроде `x isNotEqualTo y`.

## Карта модулей

- `ptg_main`: базовая конфигурация, CBA keybinds, вход в UI, Virtual/ACE Arsenal, копирование classname, удаление и разблокировка объекта под прицелом.
- `ptg_common`: helpers, безопасное чтение config, локализация, определение источника мода, preview path, масштабирование UI/HUD.
- `ptg_catalog`: динамический каталог `CfgVehicles`, фильтры, сортировка, тип техники, совместимые ammo boxes для статики.
- `ptg_ui`: browser-dashboard, стартовое меню, экран техники, режим водитель+стрелок, камера, телепорт, перевооружение, цели, status display, hitpoint inspector, настройки HUD/UI.
- `ptg_spawn`: request/server-named поток спавна техники, водителя/экипажа, целей, реестр созданных объектов, удаление целей и очистка полигона.
- `ptg_tracking`: projectile tracking, tracking HUD, trajectory lines, map projectile markers, submunition tracking.
- `ptg_penetration`: тест пробития, orbit-камера, тестовый projectile, damage/hitpoint/crew отчет, параметры `CfgAmmo`, инструмент `Создать взрыв` по клику на карте.
- `ptg_player`: infinite ammo, god mode, fired/respawn handlers.
- `ptg_player_ace`: блокировка ACE medical damage для god mode.
- `ptg_ace`: ACE self actions и terminal actions.

## Важные архитектурные правила

- SQF-функции добавлять как `addons/<module>/functions/fnc_name.sqf` и регистрировать в `XEH_PREP.hpp` соответствующего модуля.
- Сохранять CBA-структуру addon: `script_component.hpp`, `XEH_PREP.hpp`, XEH init-файлы, `CfgEventHandlers.hpp`, `config.cpp`.
- Использовать macros `FUNC`, `EFUNC`, `QFUNC`, `GVAR`, `QGVAR`; не собирать имена функций/переменных вручную без причины.
- Runtime-состояние хранить существующими ключами `mkk_ptg_` в `missionNamespace`/`uiNamespace` и очищать при остановке: камеры, handlers, HUD layers, Draw3D/PFH, markers, созданные объекты.
- Dashboard, каталог, цели, перевооружение, penetration и explosion используют локальную HTML-страницу `addons/ui/web/main.html` через `RscWebBrowser`. HTML/JS — слой отображения; игровая логика и создание объектов остаются в SQF.
- Browser state передавать через существующий `pushWebState`/`ExecJS`/`ToBase64`, пользовательские действия принимать через существующий `handleWebEvent`/`JSDialog`.
- Для режима “Создать с экипажем” сохранять текущую схему: водитель создается классом игрока, игрок садится в слот стрелка, движение идет через штатные input actions Arma 3, без ручного `setDriveOnPath`/`setVelocityModelSpace`.
- Инструмент `Создать взрыв` держать в `ptg_penetration`: список строится из `CfgAmmo` по категориям bombs/rockets/ATGM/mortars, projectile создается над кликом карты и направляется вниз, высота проверяется против `triggerDistance` при `submunitionAmmo`, tracking-камера при необходимости временно закрывает и затем возвращает окно.
- Оверлей целей поддерживает режимы `bot`, `ground`, `air`; боты — `O/B/I_Survivor_F`, техника берется из общего каталога, ground использует патрульный радиус, air — радиус и высоту.

## Читать только когда релевантно

- Идея продукта, визуальный стиль, принципы: `docs/ptg/overview.md`.
- Диалоги, browser UI, dashboard, компоновка, карточка техники, камера, перевооружение, цели: `docs/ptg/ui-ux.md`.
- Динамический каталог техники, фильтры, спавн, ящики БК, очистка: `docs/ptg/catalog-and-spawn.md`.
- Телепорт, камера, tracking, trajectory, markers, status display, hitpoint inspector, penetration, explosion, keybinds, режимы игрока: `docs/ptg/features.md`.
- Границы модулей, зависимости, UI-поверхности, локализация, игровые потоки: `docs/ptg/architecture-and-localization.md`.
- Полный исходный дизайн: `docs/ptg/design-full.md`, только если раздельных документов недостаточно.

## Предпочтительная проверка

Запускать только минимальную релевантную проверку. Не запускать широкие build/test-команды без запроса.

- Для локализации проверить, что каждый новый `STR_MKK_PTG_*` имеет `English`, `Russian`, `German`.
- Для новых SQF-функций проверить, что файл, `XEH_PREP.hpp` и места вызова используют одно имя функции.
- Для UI/HUD проверить, что IDC/layer names уникальны внутри затронутого dialog/title.
- Для browser UI проверить, что labels идут из `fnc_getWebLabels.sqf`, а не хардкодятся в HTML.
- Для камеры, tracking, explosion и HUD проверить `hasInterface` и очистку runtime-состояния.
- Для spawn/delete/targets/rearm проверить, что действия с объектами выполняются на нужной машине или через существующий request/server-named поток.
