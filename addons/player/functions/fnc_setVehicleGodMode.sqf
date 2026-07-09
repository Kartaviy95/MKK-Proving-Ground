#include "..\script_component.hpp"
/*
    Устанавливает защиту техники на машине, где она локальна.
    Реестр игроков не позволяет одному вышедшему игроку снять защиту,
    пока в технике остается другой игрок с включенным режимом бога.
*/
params [
    ["_vehicle", objNull, [objNull]],
    ["_unit", objNull, [objNull]],
    ["_enabled", false, [false]],
    ["_routeAttempts", 0, [0]]
];

if (isNull _vehicle || {_vehicle isKindOf "CAManBase"}) exitWith {};

if !(local _vehicle) exitWith {
    if (_routeAttempts < 3) then {
        [_vehicle, _unit, _enabled, _routeAttempts + 1] remoteExecCall [
            QFUNC(setVehicleGodMode),
            _vehicle
        ];
    };
};

private _protectorsKey = "mkk_ptg_godModeVehicleProtectors";
private _previousAllowDamageKey = "mkk_ptg_godModeVehiclePreviousDamageAllowed";
private _protectors = _vehicle getVariable [_protectorsKey, []];

_protectors = _protectors select {
    !isNull _x
    && {_x getVariable ["mkk_ptg_godModeUnitEnabled", false]}
    && {vehicle _x isEqualTo _vehicle}
};

if (_enabled && {!isNull _unit}) then {
    if (_protectors isEqualTo []) then {
        _vehicle setVariable [
            _previousAllowDamageKey,
            [isDamageAllowed _vehicle],
            true
        ];
    };

    _protectors pushBackUnique _unit;
} else {
    private _protectorIndex = _protectors find _unit;
    if (_protectorIndex >= 0) then {
        _protectors deleteAt _protectorIndex;
    };
};

_vehicle setVariable [_protectorsKey, _protectors, true];

if (_protectors isNotEqualTo []) then {
    _vehicle setVariable ["mkk_ptg_godModeVehicleProtected", true, true];
    _vehicle allowDamage false;
    [_vehicle, true] call FUNC(repairVehicleDamage);
} else {
    private _previousAllowDamage = _vehicle getVariable [
        _previousAllowDamageKey,
        [true]
    ];

    _vehicle allowDamage (_previousAllowDamage select 0);
    _vehicle setVariable ["mkk_ptg_godModeVehicleProtected", false, true];
    _vehicle setVariable [_previousAllowDamageKey, nil, true];
};
