#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"ace_common", "ace_interaction"};
        author = CSTRING(author);
        authors[] = {CSTRING(author)};
        VERSION_CONFIG;
    };
};
