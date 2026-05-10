#include "..\script_component.hpp"
/*
    Opens the map explosion tool.
*/
if !(hasInterface) exitWith {};

if !(isNull (findDisplay 89000)) exitWith {
    closeDialog 0;
};

[] spawn {
    closeDialog 0;
    uiSleep 0.05;
    createDialog "MKK_PTG_ExplosionDisplay";
};
