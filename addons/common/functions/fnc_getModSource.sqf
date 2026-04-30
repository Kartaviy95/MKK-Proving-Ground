#include "..\script_component.hpp"
/*
    Пытается определить источник класса по configSourceMod.
*/
params [
    ["_cfg", configNull]
];

if (isNull _cfg) exitWith {localize "STR_MKK_PTG_UNKNOWN"};

private _source = configSourceMod _cfg;
if (_source == "") then {
    _source = localize "STR_MKK_PTG_UNKNOWN";
};

_source
