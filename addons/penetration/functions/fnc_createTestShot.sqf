#include "..\script_component.hpp"
/*
    Отправляет на сервер запрос тестового выстрела.
*/
private _display = uiNamespace getVariable ["mkk_ptg_penetrationDisplay", displayNull];
if (isNull _display) exitWith {};

private _target = missionNamespace getVariable ["mkk_ptg_penetrationTarget", objNull];
if (isNull _target) exitWith {
    hint localize "STR_MKK_PTG_CREATE_TEST_TARGET_FIRST";
};

private _ctrlAmmo = _display displayCtrl 88921;
private _idx = lbCurSel _ctrlAmmo;
if (_idx < 0) exitWith {
    hint localize "STR_MKK_PTG_SELECT_AMMO_FIRST";
};

private _ammoClass = _ctrlAmmo lbData _idx;
missionNamespace setVariable ["mkk_ptg_penetrationAmmoClass", _ammoClass];

private _impactPosASL = [];
private _cameraState = missionNamespace getVariable ["mkk_ptg_penetrationCameraState", createHashMap];
private _camera = _cameraState getOrDefault ["camera", objNull];
if !(isNull _camera) then {
    _impactPosASL = getPosASL _target vectorAdd [0, 0, 1.2];
};

[_target, _ammoClass, player, _impactPosASL] remoteExecCall [QFUNC(serverFireTestShot), 2];

[_target, _ammoClass] spawn {
    params ["_target", "_ammoClass"];
    uiSleep 1.5;
    [_target, _ammoClass] call FUNC(collectDamageReport);
};
