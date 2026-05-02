#include "..\script_component.hpp"

/*
    Открывает главное окно полигона.
*/
if !(hasInterface) exitWith {};
if !([player] call FUNC(isAuthorized)) exitWith {
    [localize "STR_MKK_PTG_NO_ACCESS"] call FUNC(showTimedHint);
};

if !(isNull (findDisplay 88000)) exitWith {
    closeDialog 0;
};

createDialog "MKK_PTG_MainDisplay";
