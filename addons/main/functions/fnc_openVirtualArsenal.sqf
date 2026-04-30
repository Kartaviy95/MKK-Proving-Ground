#include "..\script_component.hpp"

/*
    Открывает полный виртуальный арсенал для локального игрока.
*/
if !(hasInterface) exitWith {};
if (isNull player || {!alive player}) exitWith {};
if !([player] call FUNC(isAuthorized)) exitWith {
    hint localize "STR_MKK_PTG_NO_ACCESS";
};
if (isNil "BIS_fnc_arsenal") exitWith {};

if !(isNull (findDisplay 88000)) then {
    closeDialog 0;
};

["Open", [true, objNull, player]] call BIS_fnc_arsenal;
