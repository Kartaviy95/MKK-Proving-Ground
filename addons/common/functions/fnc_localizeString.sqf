#include "..\script_component.hpp"
/*
    Возвращает локализованную строку, если значение ссылается на stringtable.
*/
params [
    ["_value", ""]
];

if !(_value isEqualType "") exitWith {""};
if (_value isEqualTo "") exitWith {""};

private _key = _value;
if ((count _key) > 0 && {(_key select [0, 1]) isEqualTo "$"}) then {
    _key = _key select [1, (count _key) - 1];
};

if ((count _key) >= 4 && {(toUpperANSI (_key select [0, 4])) isEqualTo "STR_"}) then {
    private _localized = localize _key;
    if (_localized != "" && {_localized != _key}) then {
        _value = _localized;
    };
};

_value
