#include "..\script_component.hpp"
/*
    Создает штатный экипаж для техники и опционально переводит его в выбранную сторону.
*/
params [
    ["_vehicle", objNull],
    ["_crewSideId", -1]
];

if (isNull _vehicle) exitWith {};

if !(_crewSideId isEqualType 0) then {
    _crewSideId = parseNumber str _crewSideId;
};
_crewSideId = round _crewSideId;

createVehicleCrew _vehicle;

private _crew = crew _vehicle;
if ((_crewSideId in [0, 1, 2]) && {_crew isNotEqualTo []}) then {
    private _crewSide = switch (_crewSideId) do {
        case 0: {east};
        case 1: {west};
        default {independent};
    };
    private _oldGroups = [];
    {
        private _group = group _x;
        if !(isNull _group) then {
            _oldGroups pushBackUnique _group;
        };
    } forEach _crew;

    private _newGroup = createGroup [_crewSide, true];
    _crew joinSilent _newGroup;

    {
        if ((units _x) isEqualTo []) then {
            deleteGroup _x;
        };
    } forEach _oldGroups;
};

{
    _x setVariable ["mkk_ptg_spawnedByPTG", true, true];
    _x setVariable ["mkk_ptg_spawnedCrewParent", _vehicle, true];
    [_x, "object"] call FUNC(registerSpawnedEntity);
} forEach crew _vehicle;
