#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

#include "initSettings.inc.sqf"

ADDON = true;

GVAR(nationMap) = createHashMapFromArray [
    ["BLU_F", "USA"],
    ["OPF_F", "Russia"],
    ["IND_F", "Independent"],
    ["rhs_faction_usarmy_d", "USA"],
    ["rhs_faction_vdv", "Russia"],
    ["rhs_faction_msv", "Russia"],
    ["CUP_B_GB", "UK"],
    ["CUP_B_BW", "Germany"]
];
