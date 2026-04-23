/*
    Пытается определить источник класса по configSourceMod.
*/
params [
    ["_cfg", configNull]
];

if (isNull _cfg) exitWith {"Unknown"};

private _source = configSourceMod _cfg;
if (_source == "") then {
    _source = "Unknown";
};

_source
