#include "..\script_component.hpp"
/*
    Stores the player-selected maximum number of projectile map markers.
*/
params [
    ["_value", "40", [""]]
];

private _limit = round (parseNumber _value);
_limit = _limit max 40;

missionNamespace setVariable ["mkk_ptg_mapProjectileMarkerLimit", _limit];
profileNamespace setVariable ["mkk_ptg_mapProjectileMarkerLimit", _limit];
saveProfileNamespace;

private _markers = missionNamespace getVariable ["mkk_ptg_mapProjectileMarkers", []];
while {(count _markers) > _limit} do {
    deleteMarkerLocal (_markers deleteAt 0);
};
missionNamespace setVariable ["mkk_ptg_mapProjectileMarkers", _markers];

[] call FUNC(pushWebState);

_limit
