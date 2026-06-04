#include "..\script_component.hpp"
/*
    Checks whether the pressed key matches the CBA keybind for map height markers.
*/
params [
    ["_key", -1, [0]],
    ["_shift", false, [false]],
    ["_ctrl", false, [false]],
    ["_alt", false, [false]]
];

private _pressedKeybind = [_key, [_shift, _ctrl, _alt]];
private _action = toLower format ["%1$%2", localize "STR_MKK_PTG_MOD_NAME", "mkk_ptg_place_map_height_marker"];
private _matchesPressedKeybind = {
    params ["_keybind"];

    if !(_keybind isEqualType [] && {(count _keybind) >= 2}) exitWith {false};

    private _keybindKey = _keybind # 0;
    if !(_keybindKey isEqualType 0) exitWith {false};

    if (_keybindKey >= 0xFA && {_keybindKey <= 0x10D}) exitWith {
        private _userAction = format ["User%1", _keybindKey - 0xFA + 1];
        inputAction _userAction > 0
    };

    (_keybindKey isEqualTo (_pressedKeybind # 0)) && {
        (_keybind # 1) isEqualTo (_pressedKeybind # 1)
    }
};

private _keybinds = [];
if !(isNil "CBA_fnc_getKeybind") then {
    private _entry = [localize "STR_MKK_PTG_MOD_NAME", "mkk_ptg_place_map_height_marker"] call CBA_fnc_getKeybind;
    if !(isNil "_entry" || {!(_entry isEqualType [])}) then {
        if ((count _entry) > 8 && {(_entry # 8) isEqualType []}) then {
            _keybinds = _entry # 8;
        } else {
            if ((count _entry) > 5 && {(_entry # 5) isEqualType []}) then {
                _keybinds = [_entry # 5];
            };
        };
    };
};

if (_keybinds isEqualTo [] && {!(isNil "CBA_fnc_hashGet")}) then {
    private _registry = profileNamespace getVariable "cba_keybinding_registry_v3";
    if !(isNil "_registry") then {
        private _storedKeybinds = [_registry, _action] call CBA_fnc_hashGet;
        if !(isNil "_storedKeybinds" || {!(_storedKeybinds isEqualType [])}) then {
            _keybinds = _storedKeybinds;
        };
    };
};

if (_keybinds isEqualTo []) exitWith {
    _pressedKeybind isEqualTo [DIK_H, [false, false, false]]
};

(_keybinds findIf {
    [_x] call _matchesPressedKeybind
}) >= 0
