#include "..\script_component.hpp"
/*
    Client-side request for a global map smoke highlight.
    Kept local for the same reason as vehicle/target spawn requests: the addon
    may be absent on a dedicated server.
*/
params [
    ["_position", [], [[]]],
    ["_color", "ColorYellow", [""]],
    ["_requestor", objNull, [objNull]]
];

if ((count _position) < 2) exitWith {false};
if (isNull _requestor) exitWith {false};
if !([_requestor] call EFUNC(main,isAuthorized)) exitWith {
    [localize "STR_MKK_PTG_NO_ACCESS"] call EFUNC(main,showTimedHint);
    false
};

private _mapPos = [_position # 0, _position # 1, 0];
[_mapPos, _color, _requestor] call FUNC(serverPlaceMapSmoke);

true
