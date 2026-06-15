#include "..\script_component.hpp"
/*
    Полная очистка сущностей полигона.
*/
private _registered = [];
{
    _registered append (missionNamespace getVariable [_x, []]);
} forEach [
    "mkk_ptg_spawnedTargets",
    "mkk_ptg_spawnedVehicles",
    "mkk_ptg_spawnedObjects"
];

private _candidates = [];
_candidates append _registered;
_candidates append (allMissionObjects "All");
_candidates append vehicles;
_candidates append allUnits;
_candidates append allDeadMen;

private _ptgEntities = [];
{
    if (!isNull _x && {[_x] call EFUNC(main,isPTGCreatedEntity)}) then {
        _ptgEntities pushBackUnique _x;
    };
} forEach _candidates;

{
    if (!isNull _x && {!isPlayer _x}) then {
        deleteVehicle _x;
    };
} forEach (_ptgEntities select {_x isKindOf "Man"});

{
    if (!isNull _x) then {
        {
            if (!isNull _x && {!isPlayer _x} && {[_x] call EFUNC(main,isPTGCreatedEntity)}) then {
                deleteVehicle _x;
            };
        } forEach crew _x;

        deleteVehicle _x;
    };
} forEach (_ptgEntities select {!(_x isKindOf "Man")});

missionNamespace setVariable ["mkk_ptg_spawnedTargets", [], true];
missionNamespace setVariable ["mkk_ptg_spawnedVehicles", [], true];
missionNamespace setVariable ["mkk_ptg_spawnedObjects", [], true];
