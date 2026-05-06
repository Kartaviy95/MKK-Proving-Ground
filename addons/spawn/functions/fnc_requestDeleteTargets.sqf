#include "..\script_component.hpp"
/*
    Клиентский запрос удаления созданных мишеней.
*/
params [
    ["_requestor", objNull]
];

if (isNull _requestor) exitWith {};
if !([_requestor] call EFUNC(main,isAuthorized)) exitWith {
    [localize "STR_MKK_PTG_NO_ACCESS"] call EFUNC(main,showTimedHint);
};

[_requestor] call FUNC(serverDeleteTargets);
