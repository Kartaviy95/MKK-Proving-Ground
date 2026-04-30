#include "..\script_component.hpp"
/*
    Открывает экран теста пробития.
*/
if !(hasInterface) exitWith {};

if !(isNull (findDisplay 88900)) exitWith {
    closeDialog 0;
};

[] spawn {
    closeDialog 0;
    uiSleep 0.05;
    createDialog "MKK_PTG_PenetrationDisplay";
};
