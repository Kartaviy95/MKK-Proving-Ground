/*
    Внутренние дефолты модуля пробития для личного использования.
    Значения можно править прямо здесь.
*/
private _setDefault = {
    params ["_name", "_value"];

    if (isNil {missionNamespace getVariable _name}) then {
        missionNamespace setVariable [_name, _value];
    };
};

{
    _x call _setDefault;
} forEach [
    ["mkk_ptg_penetrationTargetDistance", 120],
    ["mkk_ptg_penetrationShotDistance", 70]
];
