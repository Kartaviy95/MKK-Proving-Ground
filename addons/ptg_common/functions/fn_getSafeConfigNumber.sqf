/*
    Безопасно читает числовой параметр из конфига.
*/
params [
    ["_cfg", configNull],
    ["_property", ""],
    ["_fallback", 0]
];

if (isNull _cfg) exitWith {_fallback};
if !(_property isEqualType "") exitWith {_fallback};
if !isNumber (_cfg >> _property) exitWith {_fallback};

getNumber (_cfg >> _property)
