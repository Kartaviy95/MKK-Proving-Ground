#include "..\script_component.hpp"
/*
    Добавляет и заряжает магазин в выбранную турель.
    Функция специально НЕ проверяет local _vehicle: её нужно выполнять там,
    где локален стрелок выбранной турели, иначе другой игрок в этой турели
    может продолжать видеть старые магазины.
*/
params ["_vehicle", ["_turret", []], ["_weapon", ""], ["_magazine", ""]];

if (isNull _vehicle || {_weapon isEqualTo ""} || {_magazine isEqualTo ""}) exitWith {};

_vehicle addMagazineTurret [_magazine, _turret];
_vehicle loadMagazine [_turret, _weapon, _magazine];
