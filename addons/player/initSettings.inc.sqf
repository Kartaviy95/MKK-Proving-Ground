/*
    Внутренние дефолты локальных инструментов игрока.
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
    ["mkk_ptg_infiniteAmmoEnabled", false],
    ["mkk_ptg_godModeEnabled", false]
];
