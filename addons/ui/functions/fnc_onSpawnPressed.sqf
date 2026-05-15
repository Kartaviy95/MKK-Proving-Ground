#include "..\script_component.hpp"
/*
    Отправляет запрос на серверный спавн техники.
*/
params [
    ["_withCrew", false],
    ["_enterAsGunner", false]
];

private _className = missionNamespace getVariable ["mkk_ptg_currentSelection", ""];
if (_className isEqualTo "") exitWith {
    [localize "STR_MKK_PTG_SELECT_VEHICLE_FIRST"] call EFUNC(main,showTimedHint);
};

private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
private _distance = missionNamespace getVariable ["mkk_ptg_spawnDefaultDistance", 10];
private _directionOffset = 0;
private _ammoBoxClass = "";

if !(isNull _display) then {
    _distance = parseNumber ctrlText (_display displayCtrl 88015);
    _directionOffset = parseNumber ctrlText (_display displayCtrl 88016);

    if (_className isKindOf "StaticWeapon") then {
        private _ctrlAmmoBox = _display displayCtrl 88017;
        private _ammoBoxIndex = lbCurSel _ctrlAmmoBox;

        if (_ammoBoxIndex >= 0) then {
            _ammoBoxClass = _ctrlAmmoBox lbData _ammoBoxIndex;
        };
    };
};

private _driverClass = "";
if (_enterAsGunner) then {
    _driverClass = typeOf player;
};

private _vehicle = [_className, player, _withCrew, _distance, _directionOffset, _ammoBoxClass, _driverClass] call EFUNC(spawn,requestSpawnVehicle);
if (_enterAsGunner) then {
    [_vehicle] call FUNC(startCrewDriverControl);
};
