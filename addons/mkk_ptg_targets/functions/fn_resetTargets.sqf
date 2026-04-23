/*
    Базовый reset целей.
    Пока реализован как полное удаление целей.
*/
if !(isServer) exitWith {};

[] call mkk_ptg_fnc_deleteTargets;
