/*
    Отправляет запрос на серверный спавн техники.
*/
params [
    ["_withCrew", false]
];

private _className = missionNamespace getVariable ["mkk_ptg_currentSelection", ""];
if (_className isEqualTo "") exitWith {
    hint "Сначала выберите технику.";
};

[_className, player, _withCrew] call mkk_ptg_fnc_requestSpawnVehicle;
