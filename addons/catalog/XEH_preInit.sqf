#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

#include "initSettings.inc.sqf"

ADDON = true;

GVAR(nationMap) = createHashMapFromArray [
    ["BLU_F", "STR_MKK_PTG_NATION_USA"],
    ["OPF_F", "STR_MKK_PTG_NATION_RUSSIA"],
    ["IND_F", "STR_MKK_PTG_NATION_INDEPENDENT"],
    ["rhs_faction_usarmy_d", "STR_MKK_PTG_NATION_USA"],
    ["rhs_faction_vdv", "STR_MKK_PTG_NATION_RUSSIA"],
    ["rhs_faction_msv", "STR_MKK_PTG_NATION_RUSSIA"],
    ["CUP_B_GB", "STR_MKK_PTG_NATION_UK"],
    ["CUP_B_BW", "STR_MKK_PTG_NATION_GERMANY"]
];
