/*
    Проверяет, можно ли запускать tracking.
*/
params [
    ["_projectile", objNull],
    ["_ammoClass", ""]
];

if !(missionNamespace getVariable ["mkk_ptg_trackingEnabled", true]) exitWith {false};
if (isNull _projectile) exitWith {false};

private _lastTrackAt = missionNamespace getVariable ["mkk_ptg_trackingLastAt", -1000];
private _cooldown = missionNamespace getVariable ["mkk_ptg_trackingCooldown", 1];
if ((diag_tickTime - _lastTrackAt) < _cooldown) exitWith {false};

private _allowedModes = missionNamespace getVariable ["mkk_ptg_trackingAllowedAmmoKinds", ["bullet", "shell", "missile", "rocket"]];
private _cfg = configFile >> "CfgAmmo" >> _ammoClass;
private _simulation = [_cfg, "simulation", ""] call mkk_ptg_fnc_getSafeConfigText;

private _kind = "other";
if (_simulation find "shotbullet" > -1) then {_kind = "bullet"};
if (_simulation find "shotshell" > -1) then {_kind = "shell"};
if (_simulation find "shotrocket" > -1) then {_kind = "rocket"};
if (_simulation find "shotmissile" > -1) then {_kind = "missile"};

_kind in _allowedModes
