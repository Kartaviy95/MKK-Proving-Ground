#include "..\script_component.hpp"
/*
    Запускает простую orbit-камеру вокруг тестовой цели.
*/
if !(hasInterface) exitWith {};

private _target = missionNamespace getVariable ["mkk_ptg_penetrationTarget", objNull];
if (isNull _target) exitWith {
    [] spawn {
        private _timeoutAt = diag_tickTime + 2;
        waitUntil {
            !(isNull (missionNamespace getVariable ["mkk_ptg_penetrationTarget", objNull])) || {diag_tickTime > _timeoutAt}
        };

        if (isNull (missionNamespace getVariable ["mkk_ptg_penetrationTarget", objNull])) exitWith {
            [localize "STR_MKK_PTG_CREATE_TEST_TARGET_FIRST"] call EFUNC(main,showTimedHint);
        };

        [] call FUNC(startOrbitCamera);
    };
};

private _display = uiNamespace getVariable ["mkk_ptg_penetrationDisplay", displayNull];
if !(isNull _display) then {
    private _ctrlAmmo = _display displayCtrl 88921;
    private _idx = lbCurSel _ctrlAmmo;
    if (_idx >= 0) then {
        missionNamespace setVariable ["mkk_ptg_penetrationAmmoClass", _ctrlAmmo lbData _idx];
    };
};

missionNamespace setVariable ["mkk_ptg_penetrationClosingForCamera", true];
closeDialog 0;
[] call FUNC(stopOrbitCamera);
missionNamespace setVariable ["mkk_ptg_penetrationClosingForCamera", true];

private _camera = "camera" camCreate (_target modelToWorld [0, -9, 3]);
_camera cameraEffect ["Internal", "Back"];
showCinemaBorder false;

private _hudLayer = "mkk_ptg_penetrationHudLayer" call BIS_fnc_rscLayer;
_hudLayer cutRsc ["MKK_PTG_PenetrationReportHUD", "PLAIN"];

missionNamespace setVariable ["mkk_ptg_penetrationCameraState", createHashMapFromArray [
    ["camera", _camera],
    ["target", _target],
    ["angle", 180],
    ["distance", 12],
    ["height", 3]
]];

missionNamespace setVariable ["mkk_ptg_penetrationCameraRunning", true];
[] call FUNC(registerAimClick);
[] call FUNC(registerOrbitControls);
[] call FUNC(updateReport);
[localize "STR_MKK_PTG_PENETRATION_AIM_HINT"] call EFUNC(main,showTimedHint);

[] spawn {
    while {missionNamespace getVariable ["mkk_ptg_penetrationCameraRunning", false]} do {
        private _state = missionNamespace getVariable ["mkk_ptg_penetrationCameraState", createHashMap];
        private _camera = _state getOrDefault ["camera", objNull];
        private _target = _state getOrDefault ["target", objNull];
        if (isNull _camera || {isNull _target}) exitWith {};

        private _angle = _state getOrDefault ["angle", 180];
        private _distance = _state getOrDefault ["distance", 9];
        private _height = _state getOrDefault ["height", 3];

        private _pos = _target modelToWorld [
            (sin _angle) * _distance,
            (cos _angle) * _distance,
            _height
        ];
        _camera setPosATL _pos;
        _camera camSetTarget _target;
        _camera camCommit 0;
        uiSleep 0.02;
    };
};
