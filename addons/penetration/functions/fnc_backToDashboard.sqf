#include "..\script_component.hpp"
/*
    Closes the explosion tool and returns to the main dashboard.
*/
if !(hasInterface) exitWith {};

[] spawn {
    closeDialog 0;
    uiSleep 0.05;
    [] call EFUNC(main,openMainUI);
};
