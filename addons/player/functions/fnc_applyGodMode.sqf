#include "..\script_component.hpp"
/*
    Применяет или снимает локальную неуязвимость с текущего игрока.
    При включенном режиме также лечит технику, в которой сидит игрок.
*/
params [
    ["_unit", player, [objNull]],
    ["_enabled", missionNamespace getVariable ["mkk_ptg_godModeEnabled", false], [false]]
];

if (!hasInterface || {isNull _unit}) exitWith {};

private _wasEnabled = _unit getVariable ["mkk_ptg_godModeUnitEnabled", false];
private _previousAllowDamageKey = "mkk_ptg_godModePreviousDamageAllowed";
private _previousStaminaKey = "mkk_ptg_godModePreviousStaminaEnabled";
_unit setVariable ["mkk_ptg_godModeUnitEnabled", _enabled, true];

if !(isNil "ace_common_fnc_statusEffect_set") then {
    [_unit, "blockDamage", "mkk_ptg_god_mode", _enabled] call ace_common_fnc_statusEffect_set;
};

if (_enabled) then {
    if !(_wasEnabled) then {
        _unit setVariable [_previousAllowDamageKey, isDamageAllowed _unit];
        _unit setVariable [_previousStaminaKey, [isStaminaEnabled _unit]];
    };

    _unit allowDamage false;
    _unit enableStamina false;
    _unit setStamina 1;
    _unit setFatigue 0;
} else {
    if (_wasEnabled) then {
        _unit allowDamage (_unit getVariable [_previousAllowDamageKey, true]);
        _unit setVariable [_previousAllowDamageKey, nil];

        private _previousStamina = _unit getVariable [_previousStaminaKey, [true]];
        _unit enableStamina (_previousStamina select 0);
        _unit setVariable [_previousStaminaKey, nil];
    };
};

if (_enabled) then {
    _unit setDamage 0;
};

[_unit, _enabled] call FUNC(updateGodModeVehicle);

[_unit, _enabled, _wasEnabled] call FUNC(applyAceGodMode);
