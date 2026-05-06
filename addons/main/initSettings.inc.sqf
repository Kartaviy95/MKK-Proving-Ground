/*
    Внутренние дефолты полигона для личного использования.
    При необходимости меняйте значения прямо в этом файле.
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
    ["mkk_ptg_trackingEnabled", false],
    ["mkk_ptg_trackingModeDefault", "TACTICAL"],
    ["mkk_ptg_trackingMaxTime", 8],
    ["mkk_ptg_trackingCooldown", 1],
    ["mkk_ptg_trackingAllowedAmmoKinds", ["bullet", "shell", "missile", "rocket"]],
    ["mkk_ptg_spawnDefaultDistance", 10],
    ["mkk_ptg_spawnMaxDistance", 3500],
    ["mkk_ptg_trajectoryEnabled", false],
    ["mkk_ptg_mapProjectileMarkersEnabled", false],
    ["mkk_ptg_mapProjectileMarkerShowAmmo", false],
    ["mkk_ptg_hudSize", profileNamespace getVariable ["mkk_ptg_hudSize", 1]]
];
