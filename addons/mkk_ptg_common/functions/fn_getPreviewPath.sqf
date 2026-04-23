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

private _editorPreview = [_cfg, "editorPreview", ""] call mkk_ptg_fnc_getSafeConfigText;
if (_editorPreview != "") exitWith {_editorPreview};

private _picture = [_cfg, "picture", ""] call mkk_ptg_fnc_getSafeConfigText;
_picture
