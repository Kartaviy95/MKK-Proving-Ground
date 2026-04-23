#include "script_component.hpp"


class CfgPatches {
    class ADDON {
        name = QUOTE(COMPONENT);
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {QUOTE(MAIN_ADDON), "ace_interact_menu"};
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
