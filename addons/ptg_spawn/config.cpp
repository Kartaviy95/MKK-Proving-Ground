#include "script_component.hpp"

class CfgPatches {
    class mkk_ptg_spawn {
        name = "MKK PTG Spawn";
        author = "Kartaviy";
        requiredVersion = 2.14;
        requiredAddons[] = {"cba_main", "mkk_ptg_common", "mkk_ptg_catalog"};
        units[] = {};
        weapons[] = {};
    };
};

class CfgFunctions {
    class mkk_ptg {
        class spawn {
            file = "functions";
            class requestSpawnVehicle {};
            class serverSpawnVehicle {};
            class spawnCrew {};
            class removeEntity {};
            class cleanupRange {};
            class registerSpawnedEntity {};
        };
    };
};
