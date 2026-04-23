// COMPONENT should be defined in the script_component.hpp and included BEFORE this hpp

#define PREFIX mkk

#include "script_version.hpp"

#define VERSION     MAJOR.MINOR
#define VERSION_STR MAJOR.MINOR.PATCHLVL
#define VERSION_AR  MAJOR,MINOR,PATCHLVL

// MINIMAL required version for the Mod. Components can specify others..
#define REQUIRED_VERSION 2.18
#define REQUIRED_CBA_VERSION {3,18,1}
#define REQUIRED_ACE_VERSION {3,18,0}

#ifdef COMPONENT_BEAUTIFIED
    #define COMPONENT_NAME QUOTE(MKK - COMPONENT_BEAUTIFIED)
#else
    #define COMPONENT_NAME QUOTE(MKK - COMPONENT)
#endif
