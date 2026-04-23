#define PREFIX ptg

#include "script_version.hpp"

#define REQUIRED_VERSION 2.20

#ifdef COMPONENT_BEAUTIFIED
    #define COMPONENT_NAME QUOTE(PTG - COMPONENT_BEAUTIFIED)
#else
    #define COMPONENT_NAME QUOTE(PTG - COMPONENT)
#endif
