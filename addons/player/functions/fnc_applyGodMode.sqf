#include "..\script_component.hpp"
/*
    Применяет или снимает локальную неуязвимость с текущего игрока.
*/
params [
    ["_unit", player, [objNull]],
    ["_enabled", missionNamespace getVariable ["mkk_ptg_godModeEnabled", false], [false]]
];

if (!hasInterface || {isNull _unit}) exitWith {};

private _wasEnabled = _unit getVariable ["mkk_ptg_godModeUnitEnabled", false];
_unit setVariable ["mkk_ptg_godModeUnitEnabled", _enabled, true];

if !(isNil "ace_common_fnc_statusEffect_set") then {
    [_unit, "blockDamage", "mkk_ptg_god_mode", _enabled] call ace_common_fnc_statusEffect_set;
} else {
    private _previousAllowDamageKey = "mkk_ptg_godModePreviousDamageAllowed";

    if (_enabled && {!_wasEnabled}) then {
        _unit setVariable [_previousAllowDamageKey, isDamageAllowed _unit];
    };

    if (_enabled) then {
        _unit allowDamage false;
    } else {
        _unit allowDamage (_unit getVariable [_previousAllowDamageKey, true]);
        _unit setVariable [_previousAllowDamageKey, nil];
    };
};

if (_enabled) then {
    _unit setDamage 0;

    if !(_wasEnabled) then {
        if !(isNil "ace_medical_fnc_fullHeal") then {
            [_unit, objNull, false] call ace_medical_fnc_fullHeal;
        };

        if !(isNil "ace_medical_fnc_setUnconscious") then {
            [_unit, false, 0, true] call ace_medical_fnc_setUnconscious;
        };
    };
};
