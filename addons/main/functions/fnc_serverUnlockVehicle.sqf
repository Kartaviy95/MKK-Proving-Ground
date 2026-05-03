#include "..\script_component.hpp"

/*
    Validates a vehicle unlock request on server and applies it globally.
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
