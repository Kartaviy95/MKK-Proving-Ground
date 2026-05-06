#include "..\script_component.hpp"

/*
    Проверяет запрос разблокировки и применяет результат на клиентах.
    Не требует isServer: dedicated server может быть без аддона.
*/
params [
    ["_vehicle", objNull, [objNull]],
    ["_requestor", objNull, [objNull]]
];

if (isNull _vehicle || {isNull _requestor}) exitWith {};
if !([_requestor] call FUNC(isAuthorized)) exitWith {};
if (!(_vehicle isKindOf "AllVehicles") || {_vehicle isKindOf "CAManBase"}) exitWith {};

[_vehicle] call FUNC(unlockVehicleGlobal);
[_vehicle] remoteExecCall [QFUNC(unlockVehicleGlobal), -2];
