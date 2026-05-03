#include "..\script_component.hpp"

/*
    Запрашивает разблокировку техники под курсором игрока.
*/
if !(hasInterface) exitWith {};
if !([player] call FUNC(isAuthorized)) exitWith {
    [localize "STR_MKK_PTG_NO_ACCESS"] call FUNC(showTimedHint);
};

private _vehicle = cursorObject;
if (isNull _vehicle) then {
    _vehicle = cursorTarget;
};

if (isNull _vehicle || {!(_vehicle isKindOf "AllVehicles") || {_vehicle isKindOf "CAManBase"}}) exitWith {
    [localize "STR_MKK_PTG_UNLOCK_VEHICLE_NONE"] call FUNC(showTimedHint);
};

[_vehicle, player] remoteExecCall [QFUNC(serverUnlockVehicle), 2];
[localize "STR_MKK_PTG_UNLOCK_VEHICLE_REQUESTED"] call FUNC(showTimedHint);
