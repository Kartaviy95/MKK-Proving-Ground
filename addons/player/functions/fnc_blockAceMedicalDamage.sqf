#include "..\script_component.hpp"
/*
    ACE medical wound handler. Возврат [] останавливает дальнейшую обработку ран.
*/
params [["_unit", objNull, [objNull]]];

if (!isNull _unit && {_unit getVariable ["mkk_ptg_godModeUnitEnabled", false]}) exitWith {
    []
};

_this
