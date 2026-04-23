#include "script_component.hpp"

class CfgPatches {
    class mkk_ptg_catalog {
        name = "MKK PTG Catalog";
        author = "Kartaviy";
        requiredVersion = 2.14;
        requiredAddons[] = {"cba_main", "mkk_ptg_common"};
        units[] = {};
        weapons[] = {};
    };
};

class CfgFunctions {
    class mkk_ptg {
        class catalog {
            file = "functions";
            class buildVehicleCatalog {};
            class filterCatalog {};
            class sortCatalog {};
            class getVehicleInfo {};
            class getNationFromFaction {};
            class detectVehicleType {};
        };
    };
};
