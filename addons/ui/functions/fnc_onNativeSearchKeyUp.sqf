#include "..\script_component.hpp"
/*
    Synchronizes hidden native search edits with browser state.
*/
params [
    ["_control", controlNull, [controlNull]],
    ["_kind", "", [""]]
];

if (isNull _control) exitWith {};
if (_kind isEqualTo "") then {
    _kind = switch (ctrlIDC _control) do {
        case 88311: {"target"};
        default {"vehicle"};
    };
};

private _value = ctrlText _control;
switch (_kind) do {
    case "target": {
        uiNamespace setVariable ["mkk_ptg_targetSearch", _value];
    };
    case "vehicle": {
        uiNamespace setVariable ["mkk_ptg_vehicleSearch", _value];
    };
    default {};
};

if (_kind in ["target", "vehicle"]) then {
    [_kind] call FUNC(queueSearchRefresh);
};
