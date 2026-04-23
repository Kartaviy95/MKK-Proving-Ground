#include "..\script_component.hpp"
/*
    Базовый reset целей.
    Пока реализован как полное удаление целей.
*/
if !(isServer) exitWith {};

[] call FUNC(deleteTargets);
