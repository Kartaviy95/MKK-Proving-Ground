#include "..\script_component.hpp"

/*
    Проверяет серверный запрос разблокировки техники и применяет результат глобально.
*/
if !(isServer) exitWith {};

params [
    ["_vehicle", objNull, [objNull]],
    ["_requestor", objNull, [objNull]]
];

if (isNull _vehicle || {isNull _requestor}) exitWith {};
if !([_requestor] call FUNC(isAuthorized)) exitWith {};
if (!(_vehicle isKindOf "AllVehicles") || {_vehicle isKindOf "CAManBase"}) exitWith {};

[_vehicle] remoteExecCall [QFUNC(unlockVehicleGlobal), 0];
