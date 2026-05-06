#include "..\script_component.hpp"
/*
    Устанавливает нижнюю подсказку dashboard. Пустой ключ возвращает общий текст.
*/
disableSerialization;

params [["_key", "", [""]]];

private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if (isNull _display) exitWith {};

private _ctrl = _display displayCtrl 88108;
if (isNull _ctrl) exitWith {};

private _text = if (_key isEqualTo "") then {
    localize "STR_MKK_PTG_DASHBOARD_INFO"
} else {
    localize _key
};

_ctrl ctrlSetStructuredText parseText _text;
