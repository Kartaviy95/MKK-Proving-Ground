#include "..\script_component.hpp"

/*
    Открывает главное окно полигона.
*/
if !(hasInterface) exitWith {};
if !([player] call FUNC(isAuthorized)) exitWith {
    hint "Нет доступа к полигону.";
};

if !(isNull (findDisplay 88000)) exitWith {
    closeDialog 0;
};

createDialog "MKK_PTG_MainDisplay";
