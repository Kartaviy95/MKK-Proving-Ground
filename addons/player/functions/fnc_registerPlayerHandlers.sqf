#include "..\script_component.hpp"
/*
    Регистрирует обработчики локального игрока и переносит toggles на новую player unit.
*/
if !(hasInterface) exitWith {};

[] spawn {
    waitUntil {
        sleep 0.1;
        !isNull player
    };

    [] call FUNC(registerAceGodModeHandlers);

    ["vehicle", {
        params ["_unit"];

        if (
            _unit isEqualTo player
            && {missionNamespace getVariable ["mkk_ptg_godModeEnabled", false]}
        ) then {
            [_unit, true] call FUNC(applyGodMode);
        };
    }, true] call CBA_fnc_addPlayerEventHandler;

    [{
        private _currentPlayer = missionNamespace getVariable ["mkk_ptg_playerCurrentUnit", objNull];

        if (_currentPlayer isNotEqualTo player) then {
            if (!isNull _currentPlayer) then {
                [_currentPlayer, false] call FUNC(applyGodMode);
                [_currentPlayer, false] call FUNC(applyInfiniteAmmo);
            };

            missionNamespace setVariable ["mkk_ptg_playerCurrentUnit", player];

            if !(player getVariable ["mkk_ptg_playerHandlersAdded", false]) then {
                private _firedEH = player addEventHandler ["FiredMan", {
                    _this call FUNC(handleFiredMan);
                }];
                private _damageEH = player addEventHandler ["HandleDamage", {
                    _this call FUNC(handleDamage);
                }];

                player setVariable ["mkk_ptg_playerFiredEH", _firedEH];
                player setVariable ["mkk_ptg_playerDamageEH", _damageEH];
                player setVariable ["mkk_ptg_playerHandlersAdded", true];
            };

            [player, missionNamespace getVariable ["mkk_ptg_godModeEnabled", false]] call FUNC(applyGodMode);
            [player, missionNamespace getVariable ["mkk_ptg_infiniteAmmoEnabled", false]] call FUNC(applyInfiniteAmmo);
        };

        if (missionNamespace getVariable ["mkk_ptg_godModeEnabled", false]) then {
            [player, true] call FUNC(applyGodMode);
        };
    }, 1] call CBA_fnc_addPerFrameHandler;
};
