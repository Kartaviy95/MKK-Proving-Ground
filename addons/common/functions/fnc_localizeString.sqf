#include "..\script_component.hpp"
/*
    Возвращает локализованную строку, если значение ссылается на stringtable.
*/
params [
    ["_value", ""]
];

if !(_value isEqualType "") exitWith {""};
if (_value isEqualTo "") exitWith {""};

if ((_value select [0, 1]) isEqualTo "$") then {
    private _localized = localize (_value select [1]);
    if (_localized != "") exitWith {_localized};
};

_value
