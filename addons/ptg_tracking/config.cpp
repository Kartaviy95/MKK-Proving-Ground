#include "script_component.hpp"

class CfgPatches {
    class mkk_ptg_tracking {
        name = "MKK PTG Tracking";
        author = "Kartaviy";
        requiredVersion = 2.14;
        requiredAddons[] = {"cba_main", "mkk_ptg_common"};
        units[] = {};
        weapons[] = {};
    };
};

class CfgFunctions {
    class mkk_ptg {
        class tracking {
            file = "functions";
            class registerTrackingEH {};
            class canTrackProjectile {};
            class startProjectileTrack {};
            class updateProjectileTrack {};
            class stopProjectileTrack {};
            class drawTrackingHud {};
        };
    };
};
