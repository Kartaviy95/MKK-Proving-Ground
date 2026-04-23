#include "..\script_component.hpp"
/*
    Возвращает путь к превью техники.
    Приоритет:
    1. editorPreview
    2. picture
    3. пустая строка
*/
params [
    ["_cfg", configNull]
];

if (isNull _cfg) exitWith {""};

private _editorPreview = [_cfg, "editorPreview", ""] call FUNC(getSafeConfigText);
if (_editorPreview != "") exitWith {_editorPreview};

private _picture = [_cfg, "picture", ""] call FUNC(getSafeConfigText);
_picture
