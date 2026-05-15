#include "..\script_component.hpp"
/*
    Возвращает отображаемое имя текущей CBA-клавиши по action id.
*/
params [
    ["_actionId", "", [""]],
    ["_defaultKeybind", [], [[]]]
];

private _formatKeybind = {
    params ["_keybind"];

    if !(_keybind isEqualType [] && {(count _keybind) >= 2}) exitWith {""};

    private _key = _keybind # 0;
    private _modifiers = _keybind # 1;
    if !(_key isEqualType 0 && {_modifiers isEqualType [] && {(count _modifiers) >= 3}}) exitWith {""};
    if (_key < 0) exitWith {""};

    private _parts = [];
    if (_modifiers # 0) then {_parts pushBack "Shift"};
    if (_modifiers # 1) then {_parts pushBack "Ctrl"};
    if (_modifiers # 2) then {_parts pushBack "Alt"};

    private _keyName = switch (_key) do {
        case 0xC7: {"Home"};
        case 0x16: {"U"};
        case 0x17: {"I"};
        case DIK_C: {"C"};
        case DIK_F: {"F"};
        case DIK_T: {"T"};
        case DIK_ESCAPE: {"Esc"};
        case DIK_DELETE: {"Delete"};
        case DIK_LSHIFT: {"Shift"};
        case DIK_RSHIFT: {"Shift"};
        case DIK_LCONTROL: {"Ctrl"};
        case DIK_RCONTROL: {"Ctrl"};
        case DIK_LALT: {"Alt"};
        case DIK_RALT: {"Alt"};
        default {keyName _key};
    };
    if (_keyName isEqualTo "") then {_keyName = str _key;};

    _parts pushBack _keyName;
    _parts joinString "+"
};

private _findKeyName = {
    params ["_value"];

    private _keyName = "";
    private _pending = [_value];

    while {_pending isNotEqualTo [] && {_keyName isEqualTo ""}} do {
        private _item = _pending deleteAt 0;
        _keyName = _item call _formatKeybind;

        if (_keyName isEqualTo "" && {_item isEqualType []}) then {
            {
                if (_x isEqualType []) then {
                    _pending pushBack _x;
                };
            } forEach _item;
        };
    };

    _keyName
};

private _result = "";

if (_actionId isNotEqualTo "") then {
    private _action = toLower format ["%1$%2", localize "STR_MKK_PTG_MOD_NAME", _actionId];

    if !(isNil "CBA_fnc_hashGet") then {
        private _registry = profileNamespace getVariable "cba_keybinding_registry_v3";
        if !(isNil "_registry") then {
            private _storedKeybinds = [_registry, _action] call CBA_fnc_hashGet;
            if !(isNil "_storedKeybinds") then {
                _result = _storedKeybinds call _findKeyName;
            };
        };
    };

    if (_result isEqualTo "" && {!(isNil "CBA_fnc_getKeybind")}) then {
        private _entry = [localize "STR_MKK_PTG_MOD_NAME", _actionId] call CBA_fnc_getKeybind;
        if !(isNil "_entry" || {!(_entry isEqualType [])}) then {
            if ((count _entry) > 8 && {(_entry # 8) isEqualType []}) then {
                _result = (_entry # 8) call _findKeyName;
            };

            if (_result isEqualTo "") then {
                if ((count _entry) > 5 && {(_entry # 5) isEqualType []}) then {
                    _result = (_entry # 5) call _findKeyName;
                } else {
                    _result = _entry call _findKeyName;
                };
            };
        };
    };
};

if (_result isEqualTo "") then {
    _result = _defaultKeybind call _formatKeybind;
};

_result
