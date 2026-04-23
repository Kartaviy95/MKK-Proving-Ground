/*
    Проверяет, может ли игрок пользоваться полигоном.
*/
params [
    ["_unit", objNull]
];

if (isNull _unit) exitWith {false};

if !(missionNamespace getVariable ["mkk_ptg_enable", true]) exitWith {false};

if (missionNamespace getVariable ["mkk_ptg_allowAllUsers", true]) exitWith {true};

private _mode = missionNamespace getVariable ["mkk_ptg_accessMode", "ALL"];
private _whitelist = missionNamespace getVariable ["mkk_ptg_accessWhitelist", []];

switch (toUpperANSI _mode) do {
    case "ALL": {true};
    case "WHITELIST": {(getPlayerUID _unit) in _whitelist};
    case "ADMIN": {serverCommandAvailable "#kick"};
    default {false};
};
