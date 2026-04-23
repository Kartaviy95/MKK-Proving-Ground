#define COMPONENT sys
#include "script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE

#ifdef DEBUG_ENABLED_SYS
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_SYS
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SYS
#endif

#include "script_macros.hpp"
