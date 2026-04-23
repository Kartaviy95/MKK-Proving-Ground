/*
    Безопасно читает строковый параметр из конфига.
*/
params [
    ["_cfg", configNull],
    ["_property", ""],
    ["_fallback", ""]
];

if (isNull _cfg) exitWith {_fallback};
if !(_property isEqualType "") exitWith {_fallback};
if !isText (_cfg >> _property) exitWith {_fallback};

getText (_cfg >> _property)
