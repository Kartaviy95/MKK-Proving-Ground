#include "..\script_component.hpp"
/*
    Блокирует и очищает локальные состояния ACE, мешающие режиму бога.
    Все обращения к ACE защищены проверками, чтобы ptg_player не получил
    обязательную зависимость от ACE.
*/
params [
    ["_unit", player, [objNull]],
    ["_enabled", true, [false]],
    ["_wasEnabled", false, [false]]
];

if (!hasInterface || {isNull _unit}) exitWith {};

private _previousHearingKey = "mkk_ptg_godModePreviousAceHearingDamageCoefficient";
private _previousGForceKey = "mkk_ptg_godModePreviousAceGForceCoef";

if !(_enabled) exitWith {
    private _previousHearing = _unit getVariable [_previousHearingKey, []];
    if (_previousHearing isNotEqualTo []) then {
        missionNamespace setVariable ["ace_hearing_damageCoefficent", _previousHearing select 0];
        _unit setVariable [_previousHearingKey, nil];
    };

    if !(isNil "ace_hearing_fnc_updateVolume") then {
        [true] call ace_hearing_fnc_updateVolume;
    };

    private _previousGForce = _unit getVariable [_previousGForceKey, []];
    if (_previousGForce isNotEqualTo []) then {
        _previousGForce params ["_hadCustomCoefficient", "_coefficient"];
        if (_hadCustomCoefficient) then {
            _unit setVariable ["ACE_GForceCoef", _coefficient];
        } else {
            _unit setVariable ["ACE_GForceCoef", nil];
        };
        _unit setVariable [_previousGForceKey, nil];
    };

    if !(isNil "ace_gforces_GForces_CC") then {
        ace_gforces_GForces_CC ppEffectEnable true;
    };

    if !(isNil "ace_advanced_fatigue_ppeBlackout") then {
        ace_advanced_fatigue_ppeBlackout ppEffectEnable true;
    };

    if (_unit isEqualTo player) then {
        private _vignette = (findDisplay 46) displayCtrl 1202;
        if (!isNull _vignette) then {
            _vignette ctrlShow true;
        };

        if (
            !(isNil "ace_goggles_fnc_applyGlassesEffect")
            && {goggles player isNotEqualTo ""}
        ) then {
            [player, goggles player] call ace_goggles_fnc_applyGlassesEffect;
        };
    };
};

if (
    (_unit getVariable [_previousHearingKey, []]) isEqualTo []
    && {!(isNil "ace_hearing_damageCoefficent")}
) then {
    _unit setVariable [_previousHearingKey, [ace_hearing_damageCoefficent]];
};

if !(isNil "ace_hearing_damageCoefficent") then {
    ace_hearing_damageCoefficent = 0;
    ace_hearing_deafnessDV = 0;
    ace_hearing_deafnessPrior = 0;
    ace_hearing_time3 = CBA_missionTime;

    if !(isNil "ace_hearing_fnc_updateVolume") then {
        [true] call ace_hearing_fnc_updateVolume;
    };
};

if (
    (_unit getVariable [_previousGForceKey, []]) isEqualTo []
    && {!(isNil "ace_gforces_fnc_pfhUpdateGForces")}
) then {
    private _hadCustomCoefficient = !(isNil {_unit getVariable "ACE_GForceCoef"});
    _unit setVariable [
        _previousGForceKey,
        [_hadCustomCoefficient, _unit getVariable ["ACE_GForceCoef", 0]]
    ];
};

if !(isNil "ace_gforces_fnc_pfhUpdateGForces") then {
    _unit setVariable ["ACE_GForceCoef", 0.001];

    if !(isNil "ace_gforces_GForces") then {
        ace_gforces_GForces = ace_gforces_GForces apply {1};
    };

    if !(isNil "ace_gforces_GForces_CC") then {
        ace_gforces_GForces_CC ppEffectEnable false;
    };
};

if !(isNil "ace_advanced_fatigue_fnc_handleEffects") then {
    ace_advanced_fatigue_ae1Reserve = 4000000;
    ace_advanced_fatigue_ae2Reserve = 84000;
    ace_advanced_fatigue_anReserve = 2300;
    ace_advanced_fatigue_anFatigue = 0;
    ace_advanced_fatigue_muscleDamage = 0;
    ace_advanced_fatigue_respiratoryRate = 0;
    ace_advanced_fatigue_ppeBlackoutLast = 100;
    _unit setVariable ["ace_advanced_fatigue_aimFatigue", 0];

    if !(isNil "ace_advanced_fatigue_fnc_handleStaminaBar") then {
        [1] call ace_advanced_fatigue_fnc_handleStaminaBar;
    };

    if !(isNil "ace_advanced_fatigue_ppeBlackout") then {
        ace_advanced_fatigue_ppeBlackout ppEffectEnable false;
    };

    if !(isNil "ace_common_fnc_statusEffect_set") then {
        [_unit, "forceWalk", "ace_advanced_fatigue", false] call ace_common_fnc_statusEffect_set;
        [_unit, "blockSprint", "ace_advanced_fatigue", false] call ace_common_fnc_statusEffect_set;
    };
};

if ((_unit getVariable ["ace_fire_intensity", 0]) > 0) then {
    _unit setVariable ["ace_fire_intensity", 0, true];
};

private _burnUIPFH = _unit getVariable ["ace_fire_burnUIPFH", -1];
if (_burnUIPFH >= 0) then {
    _burnUIPFH call CBA_fnc_removePerFrameHandler;
    _unit setVariable ["ace_fire_burnUIPFH", nil];
};

"ace_fire_indicatorLayer" cutText ["", "PLAIN"];

private _needsFullHeal = !_wasEnabled
    || {_unit getVariable ["ACE_isUnconscious", false]}
    || {_unit getVariable ["ace_medical_isLimping", false]}
    || {(_unit getVariable ["ace_medical_pain", 0]) > 0};

if (
    !_needsFullHeal
    && {!(isNil "ace_medical_fnc_isInjured")}
) then {
    _needsFullHeal = _unit call ace_medical_fnc_isInjured;
};

if (_needsFullHeal && {!(isNil "ace_medical_fnc_fullHeal")}) then {
    [_unit, objNull, false] call ace_medical_fnc_fullHeal;
};

if (
    _unit getVariable ["ACE_isUnconscious", false]
    && {!(isNil "ace_medical_fnc_setUnconscious")}
) then {
    [_unit, false, 0, true] call ace_medical_fnc_setUnconscious;
};

if !(isNil "ace_medical_fnc_adjustPainLevel") then {
    [_unit, -1] call ace_medical_fnc_adjustPainLevel;
};

resetCamShake;
[nil, 0] call BIS_fnc_dirtEffect;

if (_unit isNotEqualTo player) exitWith {};

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

if !(isNil "ace_medical_feedback_fnc_handleHUDIndicators") then {
    [true] call ace_medical_feedback_fnc_handleHUDIndicators;
};

{
    if !(isNil _x) then {
        private _effect = missionNamespace getVariable _x;
        if (_effect >= 0) then {
            _effect ppEffectEnable false;
        };
    };
} forEach [
    "ace_medical_feedback_ppIncapacitationBlur",
    "ace_medical_feedback_ppIncapacitationGlare",
    "ace_grenades_flashbangPPEffectCC"
];

if !(isNil "ace_common_fnc_setDisableUserInputStatus") then {
    ["unconscious", false] call ace_common_fnc_setDisableUserInputStatus;
};

if !(isNil "ace_common_fnc_setHearingCapability") then {
    ["ace_medical_feedback", 1, false] call ace_common_fnc_setHearingCapability;
};

if !(isNil "ace_goggles_fnc_removeGlassesEffect") then {
    player setVariable ["ace_goggles_Condition", [false, [false, 0, 0, 0], false]];
    call ace_goggles_fnc_removeGlassesEffect;
} else {
    {
        private _display = findDisplay _x;
        if (!isNull _display) then {
            _display closeDisplay 0;
        };
    } forEach [1044, 1045];
};

private _vignette = (findDisplay 46) displayCtrl 1202;
if (!isNull _vignette) then {
    _vignette ctrlSetFade 1;
    _vignette ctrlCommit 0;
    _vignette ctrlShow false;
};
