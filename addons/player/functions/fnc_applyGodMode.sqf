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
    resetCamShake;

    [nil, 0] call BIS_fnc_dirtEffect;

    if !(isNil "ace_medical_fnc_adjustPainLevel") then {
        [_unit, -1] call ace_medical_fnc_adjustPainLevel;
    };

    if (_unit isEqualTo player) then {
        if !(isNil "ace_medical_feedback_fnc_handleEffects") then {
            [true] call ace_medical_feedback_fnc_handleEffects;
        };

        if (
            !(isNil "ace_medical_feedback_fnc_effectPain")
            && {!(isNil "ace_medical_feedback_ppPain")}
            && {!(isNil "ace_medical_feedback_ppPainBlur")}
        ) then {
            [false, 0] call ace_medical_feedback_fnc_effectPain;
        };

        if !(isNil "ace_medical_feedback_fnc_effectBloodVolume") then {
            [false, 0] call ace_medical_feedback_fnc_effectBloodVolume;
        };

        if (
            !(isNil "ace_medical_feedback_fnc_effectBloodVolumeIcon")
            && {!(isNil "ace_medical_feedback_showBloodVolumeIcon")}
        ) then {
            [false, 0] call ace_medical_feedback_fnc_effectBloodVolumeIcon;
        };

        if !(isNil "ace_medical_feedback_fnc_effectBleeding") then {
            [false, 0, true] call ace_medical_feedback_fnc_effectBleeding;
        };

        if (
            !(isNil "ace_medical_feedback_fnc_effectUnconscious")
            && {!(isNil "ace_medical_feedback_ppUnconsciousBlur")}
            && {!(isNil "ace_medical_feedback_ppUnconsciousBlackout")}
        ) then {
            [false, 0] call ace_medical_feedback_fnc_effectUnconscious;
        };

        if !(isNil "ace_goggles_fnc_removeGlassesEffect") then {
            player setVariable ["ace_goggles_Condition", [false, [false, 0, 0, 0], false]];
            call ace_goggles_fnc_removeGlassesEffect;
        } else {
            if (!isNull findDisplay 1044) then {
                (findDisplay 1044) closeDisplay 0;
            };

            if (!isNull findDisplay 1045) then {
                (findDisplay 1045) closeDisplay 0;
            };
        };

        private _vignette = (findDisplay 46) displayCtrl 1202;

        if (!isNull _vignette) then {
            _vignette ctrlSetFade 1;
            _vignette ctrlCommit 0;
            _vignette ctrlShow false;
        };
    };

    if !(_wasEnabled) then {
        if !(isNil "ace_medical_fnc_fullHeal") then {
            [_unit, objNull, false] call ace_medical_fnc_fullHeal;
        };

        if !(isNil "ace_medical_fnc_setUnconscious") then {
            [_unit, false, 0, true] call ace_medical_fnc_setUnconscious;
        };
    };
} else {
    if (_unit isEqualTo player) then {
        private _vignette = (findDisplay 46) displayCtrl 1202;

        if (!isNull _vignette) then {
            _vignette ctrlShow true;
        };

        if (
            !(isNil "ace_goggles_fnc_applyGlassesEffect")
            && {goggles player != ""}
        ) then {
            [player, goggles player] call ace_goggles_fnc_applyGlassesEffect;
        };
    };
};
