#include "..\script_component.hpp"

/*
    Возвращает нацию по фракции.
*/
params [
    ["_factionClass", ""]
];

if (EGVAR(main,nationMap) isEqualType createHashMap) then {
    if (EGVAR(main,nationMap) getOrDefault [_factionClass, ""] != "") exitWith {EGVAR(main,nationMap) get _factionClass};
};

"$STR_MKK_PTG_UNKNOWN"
