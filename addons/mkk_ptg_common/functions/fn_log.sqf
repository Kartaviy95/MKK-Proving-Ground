/*
    Локальный логгер модуля полигона.
*/
params [
    ["_message", ""],
    ["_level", "INFO"]
];

private _prefix = "[MKK-PTG]";
diag_log text format ["%1 [%2] %3", _prefix, _level, _message];
