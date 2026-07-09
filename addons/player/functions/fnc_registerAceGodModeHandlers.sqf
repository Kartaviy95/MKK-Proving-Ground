#include "..\script_component.hpp"
/*
    После ACE-событий очищает эффекты сразу и повторно на следующем кадре.
    Это нужно для flashbang и кратковременных medical/fire эффектов,
    которые создаются независимо от обычного HandleDamage.
*/
if !(hasInterface) exitWith {};
if (missionNamespace getVariable ["mkk_ptg_aceGodModeHandlersRegistered", false]) exitWith {};

missionNamespace setVariable ["mkk_ptg_aceGodModeHandlersRegistered", true];

{
    [_x, {
        if !(missionNamespace getVariable ["mkk_ptg_godModeEnabled", false]) exitWith {};

        private _subject = _this param [0, objNull];
        if (
            _subject isEqualType objNull
            && {!isNull _subject}
            && {_subject isNotEqualTo player}
        ) exitWith {};

        if (
            !isNull player
            && {player getVariable ["mkk_ptg_godModeUnitEnabled", false]}
        ) then {
            [player, true, true] call FUNC(applyAceGodMode);
        };

        [{
            if (
                missionNamespace getVariable ["mkk_ptg_godModeEnabled", false]
                && {!isNull player}
                && {player getVariable ["mkk_ptg_godModeUnitEnabled", false]}
            ) then {
                [player, true, true] call FUNC(applyAceGodMode);
            };
        }, [], 0] call CBA_fnc_waitAndExecute;
    }] call CBA_fnc_addEventHandler;
} forEach [
    "ace_flashbangExploded",
    "ace_fire_burn",
    "ace_medical_injured",
    "ace_medical_fracture",
    "ace_medical_woundReceived",
    "ace_unconscious"
];
