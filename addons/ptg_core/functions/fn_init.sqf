/*
    Общая инициализация полигона.
*/
missionNamespace setVariable ["mkk_ptg_spawnedVehicles", missionNamespace getVariable ["mkk_ptg_spawnedVehicles", []]];
missionNamespace setVariable ["mkk_ptg_spawnedTargets", missionNamespace getVariable ["mkk_ptg_spawnedTargets", []]];
missionNamespace setVariable ["mkk_ptg_spawnedObjects", missionNamespace getVariable ["mkk_ptg_spawnedObjects", []]];
missionNamespace setVariable ["mkk_ptg_trackingState", missionNamespace getVariable ["mkk_ptg_trackingState", createHashMap]];

private _nationMap = createHashMapFromArray [
    ["BLU_F", "USA"],
    ["OPF_F", "Russia"],
    ["IND_F", "Independent"],
    ["rhs_faction_usarmy_d", "USA"],
    ["rhs_faction_vdv", "Russia"],
    ["rhs_faction_msv", "Russia"],
    ["CUP_B_GB", "UK"],
    ["CUP_B_BW", "Germany"]
];
missionNamespace setVariable ["mkk_ptg_nationMap", _nationMap];

[] call mkk_ptg_fnc_registerSettings;
[] call mkk_ptg_fnc_registerKeybinds;

if (hasInterface) then {
    [] call mkk_ptg_fnc_buildVehicleCatalog;
    [] call mkk_ptg_fnc_registerTrackingEH;
};

["Инициализация MKK PTG завершена."] call mkk_ptg_fnc_log;
