#include "..\script_component.hpp"
/*
    Keeps the crew side selector aligned with the selected vehicle until the
    user picks a side manually.
*/
params [
    ["_force", false]
];

if (!_force && {uiNamespace getVariable ["mkk_ptg_vehicleCrewSideTouched", false]}) exitWith {};

private _sideId = -1;
private _className = missionNamespace getVariable ["mkk_ptg_currentSelection", ""];
if (_className isNotEqualTo "") then {
    private _cfg = configFile >> "CfgVehicles" >> _className;
    if (isClass _cfg) then {
        _sideId = [_cfg, "side", -1] call EFUNC(common,getSafeConfigNumber);
    };
};

if !(_sideId in [0, 1, 2]) then {
    _sideId = switch (side (group player)) do {
        case east: {0};
        case west: {1};
        case independent: {2};
        default {1};
    };
};

uiNamespace setVariable ["mkk_ptg_vehicleCrewSide", _sideId];
