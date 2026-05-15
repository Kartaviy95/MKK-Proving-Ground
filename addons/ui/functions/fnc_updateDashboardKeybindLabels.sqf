#include "..\script_component.hpp"
/*
    Обновляет подписи dashboard-кнопок, у которых есть CBA keybind.
*/
disableSerialization;

private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if (isNull _display) exitWith {};

private _fncLabel = {
    params [
        ["_labelKey", "", [""]],
        ["_actionId", "", [""]],
        ["_defaultKeybind", [], [[]]]
    ];

    private _label = localize _labelKey;
    private _keyName = if (isNil "ptg_main_fnc_getKeybindName") then {""} else {
        [_actionId, _defaultKeybind] call EFUNC(main,getKeybindName)
    };

    if (_keyName isEqualTo "") exitWith {
        _label
    };

    format [localize "STR_MKK_PTG_KEYBIND_LABEL_FORMAT", _label, _keyName]
};

private _ctrlTeleport = _display displayCtrl 88101;
if !(isNull _ctrlTeleport) then {
    _ctrlTeleport ctrlSetText ([
        "STR_MKK_PTG_TELEPORT",
        "mkk_ptg_start_teleport",
        [DIK_T, [false, false, false]]
    ] call _fncLabel);
};

private _ctrlUnlock = _display displayCtrl 88106;
if !(isNull _ctrlUnlock) then {
    _ctrlUnlock ctrlSetText ([
        "STR_MKK_PTG_UNLOCK_VEHICLE",
        "mkk_ptg_unlock_cursor_vehicle",
        [DIK_F, [false, true, false]]
    ] call _fncLabel);
};
