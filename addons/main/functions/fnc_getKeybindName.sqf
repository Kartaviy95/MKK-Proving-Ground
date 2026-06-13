#include "..\script_component.hpp"
/*
    Возвращает отображаемое имя текущей CBA-клавиши по action id.
*/
params [
    ["_actionId", "", [""]],
    ["_defaultKeybind", [], [[]]]
];

private _stripKeyNameQuotes = {
    params [["_keyName", "", [""]]];

    if ((count _keyName) >= 2 && {
        (_keyName select [0, 1]) isEqualTo """" && {
            (_keyName select [(count _keyName) - 1, 1]) isEqualTo """"
        }
    }) then {
        _keyName = _keyName select [1, (count _keyName) - 2];
    };

    _keyName
};

private _formatKeybind = {
    params ["_keybind"];

    if !(_keybind isEqualType [] && {(count _keybind) >= 2}) exitWith {""};

    private _key = _keybind # 0;
    private _modifiers = _keybind # 1;
    if !(_key isEqualType 0 && {_modifiers isEqualType [] && {(count _modifiers) >= 3}}) exitWith {""};
    if (_key <= 0) exitWith {""};

    if (_key >= 0xFA && {_key <= 0x10D}) then {
        private _userAction = format ["User%1", _key - 0xFA + 1];
        private _userActionKeys = actionKeysNamesArray [_userAction, 1, "Unsorted"];
        if (_userActionKeys isNotEqualTo [] && {(_userActionKeys # 0) isNotEqualTo ""}) exitWith {
            [_userActionKeys # 0] call _stripKeyNameQuotes
        };

        private _userActionName = actionName _userAction;
        if (_userActionName isNotEqualTo "") exitWith {[_userActionName] call _stripKeyNameQuotes};
    };

    private _parts = [];
    if (_modifiers # 0) then {_parts pushBack "Shift"};
    if (_modifiers # 1) then {_parts pushBack "Ctrl"};
    if (_modifiers # 2) then {_parts pushBack "Alt"};

    private _keyName = switch (_key) do {
        case 0xF0: {keyName 0x10000};
        case 0xF1: {keyName 0x10081};
        case 0xF2: {keyName 0x10002};
        case 0xF3: {keyName 0x10003};
        case 0xF4: {keyName 0x10004};
        case 0xF5: {keyName 0x10005};
        case 0xF6: {keyName 0x10006};
        case 0xF7: {keyName 0x10007};
        case 0xF8: {keyName 0x100004};
        case 0xF9: {keyName 0x100005};
        case 0xFA: {actionName "User1"};
        case 0xFB: {actionName "User2"};
        case 0xFC: {actionName "User3"};
        case 0xFD: {actionName "User4"};
        case 0xFE: {actionName "User5"};
        case 0xFF: {actionName "User6"};
        case 0x100: {actionName "User7"};
        case 0x101: {actionName "User8"};
        case 0x102: {actionName "User9"};
        case 0x103: {actionName "User10"};
        case 0x104: {actionName "User11"};
        case 0x105: {actionName "User12"};
        case 0x106: {actionName "User13"};
        case 0x107: {actionName "User14"};
        case 0x108: {actionName "User15"};
        case 0x109: {actionName "User16"};
        case 0x10A: {actionName "User17"};
        case 0x10B: {actionName "User18"};
        case 0x10C: {actionName "User19"};
        case 0x10D: {actionName "User20"};
        case 0xC7: {"Home"};
        case 0x16: {"U"};
        case 0x17: {"I"};
        case DIK_C: {"C"};
        case DIK_F: {"F"};
        case DIK_K: {"K"};
        case DIK_T: {"T"};
        case DIK_X: {"X"};
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
    _keyName = [_keyName] call _stripKeyNameQuotes;

    _parts pushBack _keyName;
    _parts joinString "+"
};

private _findKeyNames = {
    params ["_value"];

    private _keyNames = [];
    private _pending = [_value];

    while {_pending isNotEqualTo []} do {
        private _item = _pending deleteAt 0;
        private _keyName = [_item] call _formatKeybind;

        if (_keyName isNotEqualTo "") then {
            _keyNames pushBackUnique _keyName;
        } else {
            if (_item isEqualType []) then {
                {
                    if (_x isEqualType []) then {
                        _pending pushBack _x;
                    };
                } forEach _item;
            };
        };
    };

    _keyNames
};

private _formatKeyNames = {
    params ["_value"];

    private _keyNames = [_value] call _findKeyNames;
    _keyNames joinString " / "
};

private _result = "";

if (_actionId isNotEqualTo "") then {
    if !(isNil "CBA_fnc_getKeybind") then {
        private _entry = [localize "STR_MKK_PTG_MOD_NAME", _actionId] call CBA_fnc_getKeybind;
        if !(isNil "_entry" || {!(_entry isEqualType [])}) then {
            if ((count _entry) > 8 && {(_entry # 8) isEqualType []}) then {
                _result = [_entry # 8] call _formatKeyNames;
            };

            if (_result isEqualTo "") then {
                if ((count _entry) > 5 && {(_entry # 5) isEqualType []}) then {
                    _result = [_entry # 5] call _formatKeyNames;
                } else {
                    _result = [_entry] call _formatKeyNames;
                };
            };
        };
    };

    if (_result isEqualTo "" && {!(isNil "CBA_fnc_hashGet")}) then {
        private _action = toLower format ["%1$%2", localize "STR_MKK_PTG_MOD_NAME", _actionId];
        private _registry = profileNamespace getVariable "cba_keybinding_registry_v3";
        if !(isNil "_registry") then {
            private _storedKeybinds = [_registry, _action] call CBA_fnc_hashGet;
            if !(isNil "_storedKeybinds") then {
                _result = [_storedKeybinds] call _formatKeyNames;
            };
        };
    };
};

if (_result isEqualTo "") then {
    _result = [_defaultKeybind] call _formatKeybind;
};

_result
