#include "..\script_component.hpp"

/*
    Возвращает нацию по фракции.
*/
params [
    ["_factionClass", ""]
];

if (GVAR(nationMap) isEqualType createHashMap) then {
    if (GVAR(nationMap) getOrDefault [_factionClass, ""] != "") exitWith {GVAR(nationMap) get _factionClass};
};

"STR_MKK_PTG_UNKNOWN"
