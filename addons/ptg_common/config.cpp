#include "script_component.hpp"

class CfgPatches {
    class mkk_ptg_common {
        name = "MKK PTG Common";
        author = "Kartaviy";
        requiredVersion = 2.14;
        requiredAddons[] = {"cba_main"};
        units[] = {};
        weapons[] = {};
    };
};

class CfgFunctions {
    class mkk_ptg {
        class common {
            file = "functions";
            class isAuthorized {};
            class log {};
            class getSafeConfigText {};
            class getSafeConfigNumber {};
            class getPreviewPath {};
            class getModSource {};
        };
    };
};
