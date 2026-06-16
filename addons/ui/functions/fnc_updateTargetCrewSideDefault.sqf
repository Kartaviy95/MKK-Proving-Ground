#include "..\script_component.hpp"
/*
    Keeps the target crew side aligned with the selected target vehicle until
    the user picks a side manually.
*/
params [
    ["_force", false]
];

if (!_force && {uiNamespace getVariable ["mkk_ptg_targetCrewSideTouched", false]}) exitWith {};

private _sideId = -1;
private _className = missionNamespace getVariable ["mkk_ptg_targetSelection", ""];
if (_className isNotEqualTo "") then {
    private _cfg = configFile >> "CfgVehicles" >> _className;
    if (isClass _cfg) then {
        _sideId = [_cfg, "side", -1] call EFUNC(common,getSafeConfigNumber);
    };
};

if !(_sideId in [0, 1, 2]) then {
    private _playerSideId = switch (side (group player)) do {
        case east: {0};
        case west: {1};
        case independent: {2};
        default {1};
    };
    _sideId = switch (_playerSideId) do {
        case 0: {1};
        case 1: {0};
        default {0};
    };
};

uiNamespace setVariable ["mkk_ptg_targetCrewSide", _sideId];
