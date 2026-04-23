#include "script_component.hpp"

class CfgPatches {
    class mkk_ptg_core {
        name = "MKK PTG Core";
        author = "Kartaviy";
        requiredVersion = 2.14;
        requiredAddons[] = {
            "cba_main",
            "mkk_ptg_common",
            "mkk_ptg_catalog",
            "mkk_ptg_ui",
            "mkk_ptg_spawn",
            "mkk_ptg_targets",
            "mkk_ptg_tracking"
        };
        units[] = {};
        weapons[] = {};
    };
};

class CfgFunctions {
    class mkk_ptg {
        class core {
            file = "functions";
            class init {postInit = 1;};
            class registerSettings {};
            class registerKeybinds {};
            class openMainUI {};
        };
    };
};

class CfgRemoteExec {
    class Functions {
        mode = 1;
        jip = 0;
        class mkk_ptg_fnc_serverSpawnVehicle {allowedTargets = 2;};
        class mkk_ptg_fnc_cleanupRange {allowedTargets = 2;};
        class mkk_ptg_fnc_spawnStaticTarget {allowedTargets = 2;};
        class mkk_ptg_fnc_spawnInfantryTarget {allowedTargets = 2;};
        class mkk_ptg_fnc_deleteTargets {allowedTargets = 2;};
    };
};
