#include "..\script_component.hpp"
/*
    Применяет loadout пилона.
    Если за turretPath сидит игрок, операция маршрутизируется на его клиент —
    это убирает рассинхрон, когда другой стрелок продолжает видеть старый loadout.
    Если стрелка нет, выполняем локально у нажавшего игрока, как в proving_ground,
    чтобы не зависеть от наличия аддона на dedicated server.
*/
params ["_vehicle", "_pylonIndex", ["_magazine", ""], ["_turretPath", []], ["_routed", false]];

if (isNull _vehicle || {_pylonIndex < 1}) exitWith {};

if (!_routed) then {
    private _targetUnit = [_vehicle, _turretPath] call FUNC(getRearmExecutionTarget);
    if (!isNull _targetUnit && {!local _targetUnit}) exitWith {
        [_vehicle, _pylonIndex, _magazine, _turretPath, true] remoteExecCall [QFUNC(applyPylonLoadout), _targetUnit];
    };
};

_vehicle setPylonLoadout [_pylonIndex, _magazine, true, _turretPath];
