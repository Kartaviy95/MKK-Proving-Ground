#include "..\script_component.hpp"

/*
    Открывает полный ACE3 арсенал для локального игрока.
*/
if !(hasInterface) exitWith {};
if (isNull player || {!alive player}) exitWith {};
if !([player] call FUNC(isAuthorized)) exitWith {
    [localize "STR_MKK_PTG_NO_ACCESS"] call FUNC(showTimedHint);
};
if (isNil "ace_arsenal_fnc_openBox") exitWith {};

if !(isNull (findDisplay 88000)) then {
    closeDialog 0;
};

[player, player, true] call ace_arsenal_fnc_openBox;
