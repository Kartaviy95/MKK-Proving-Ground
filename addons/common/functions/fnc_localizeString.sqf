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
if ((_key select [0, 1]) isEqualTo "$") then {
    _key = _key select [1];
};

if ((toUpperANSI (_key select [0, 4])) isEqualTo "STR_") then {
    private _localized = localize _key;
    if (_localized != "" && {_localized != _key && {_localized != _value}}) exitWith {_localized};
};

_value
