#include "..\script_component.hpp"
/*
    Проверяет, совпадает ли нажатие с CBA keybind "Закрыть камеру".
    Нужен отдельный перехват ESC, потому что обычный игровой ESC открывает pause menu.
*/
params [
    ["_key", -1, [0]],
    ["_shift", false, [false]],
    ["_ctrl", false, [false]],
    ["_alt", false, [false]]
];

private _pressedKeybind = [_key, [_shift, _ctrl, _alt]];
private _action = toLower format ["%1$%2", localize "STR_MKK_PTG_MOD_NAME", "mkk_ptg_close_map_camera"];
private _matchesPressedKeybind = {
    params ["_keybind"];

    _keybind isEqualType [] && {
        (count _keybind) >= 2 && {
            (_keybind # 0) isEqualTo (_pressedKeybind # 0) && {
                (_keybind # 1) isEqualTo (_pressedKeybind # 1)
            }
        }
    }
};

if !(isNil "CBA_fnc_hashGet") then {
    private _registry = profileNamespace getVariable "cba_keybinding_registry_v3";
    if !(isNil "_registry") then {
        private _storedKeybinds = [_registry, _action] call CBA_fnc_hashGet;
        if !(isNil "_storedKeybinds") exitWith {
            _storedKeybinds isEqualType [] && {(_storedKeybinds findIf {_x call _matchesPressedKeybind}) >= 0}
        };
    };
};

if (isNil "CBA_fnc_getKeybind") exitWith {
    _pressedKeybind isEqualTo [DIK_ESCAPE, [false, false, false]]
};

private _entry = [localize "STR_MKK_PTG_MOD_NAME", "mkk_ptg_close_map_camera"] call CBA_fnc_getKeybind;
if (isNil "_entry" || {!(_entry isEqualType [])}) exitWith {
    _pressedKeybind isEqualTo [DIK_ESCAPE, [false, false, false]]
};

private _keybinds = [];
if ((count _entry) > 8 && {(_entry # 8) isEqualType []}) then {
    _keybinds = _entry # 8;
} else {
    if ((count _entry) > 5 && {(_entry # 5) isEqualType []}) then {
        _keybinds = [_entry # 5];
    };
};

(_keybinds findIf {
    _x call _matchesPressedKeybind
}) >= 0
