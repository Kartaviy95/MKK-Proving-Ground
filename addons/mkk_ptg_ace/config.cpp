#include "script_component.hpp"

class CfgPatches {
    class mkk_ptg_ace {
        name = "MKK PTG ACE";
        author = "OpenAI";
        requiredVersion = 2.14;
        requiredAddons[] = {"cba_main", "ace_interact_menu", "mkk_ptg_core"};
        units[] = {};
        weapons[] = {};
    };
};

class CfgFunctions {
    class mkk_ptg {
        class ace {
            file = "functions";
            class initAce {postInit = 1;};
            class addSelfActions {};
            class addTerminalActions {};
        };
    };
};
