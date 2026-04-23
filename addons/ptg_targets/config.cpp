#include "script_component.hpp"

class CfgPatches {
    class mkk_ptg_targets {
        name = "MKK PTG Targets";
        author = "Kartaviy";
        requiredVersion = 2.14;
        requiredAddons[] = {"cba_main", "mkk_ptg_common"};
        units[] = {};
        weapons[] = {};
    };
};

class CfgFunctions {
    class mkk_ptg {
        class targets {
            file = "functions";
            class spawnStaticTarget {};
            class spawnInfantryTarget {};
            class resetTargets {};
            class deleteTargets {};
        };
    };
};
