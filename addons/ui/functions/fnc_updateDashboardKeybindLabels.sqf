#include "..\script_component.hpp"
/*
    Stores dashboard labels that include current keybind names.
*/
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

    if (_keyName isEqualTo "") exitWith {_label};
    format [localize "STR_MKK_PTG_KEYBIND_LABEL_FORMAT", _label, _keyName]
};

uiNamespace setVariable ["mkk_ptg_dashboardTeleportLabel", [
    "STR_MKK_PTG_TELEPORT",
    "mkk_ptg_start_teleport",
    [DIK_T, [false, false, false]]
] call _fncLabel];

uiNamespace setVariable ["mkk_ptg_dashboardUnlockLabel", [
    "STR_MKK_PTG_UNLOCK_VEHICLE",
    "mkk_ptg_unlock_cursor_vehicle",
    [DIK_F, [false, true, false]]
] call _fncLabel];

uiNamespace setVariable ["mkk_ptg_dashboardCameraLabel", [
    "STR_MKK_PTG_CAMERA",
    "mkk_ptg_start_map_camera",
    [DIK_K, [false, false, false]]
] call _fncLabel];
