#include "..\script_component.hpp"
/*
    Останавливает простую свободную камеру и очищает ее controls.
*/
if !(hasInterface) exitWith {};

missionNamespace setVariable ["mkk_ptg_mapCameraRunning", false];
missionNamespace setVariable ["mkk_ptg_mapCameraSelecting", false];
missionNamespace setVariable ["mkk_ptg_mapCameraSelectedPos", []];
missionNamespace setVariable ["mkk_ptg_mapCameraNightVision", false];
camUseNVG false;
onMapSingleClick "";
openMap false;

private _display = findDisplay 46;
private _ehs = missionNamespace getVariable ["mkk_ptg_mapCameraControlEHs", []];
if !(isNull _display) then {
    if ((count _ehs) > 0) then {_display displayRemoveEventHandler ["MouseMoving", _ehs # 0];};
    if ((count _ehs) > 1) then {_display displayRemoveEventHandler ["MouseZChanged", _ehs # 1];};
    if ((count _ehs) > 2) then {_display displayRemoveEventHandler ["MouseButtonDown", _ehs # 2];};
    if ((count _ehs) > 3) then {_display displayRemoveEventHandler ["KeyDown", _ehs # 3];};
    if ((count _ehs) > 4) then {_display displayRemoveEventHandler ["KeyUp", _ehs # 4];};
};
missionNamespace setVariable ["mkk_ptg_mapCameraControlEHs", []];
missionNamespace setVariable ["mkk_ptg_mapCameraMapKeyEHs", []];
missionNamespace setVariable ["mkk_ptg_mapCameraMarker", ""];

private _hintCtrls = missionNamespace getVariable ["mkk_ptg_mapCameraHintCtrls", []];
{
    if !(isNull _x) then {
        ctrlDelete _x;
    };
} forEach _hintCtrls;
missionNamespace setVariable ["mkk_ptg_mapCameraHintCtrls", []];
missionNamespace setVariable ["mkk_ptg_mapCameraHintVisible", true];

private _speedCtrls = missionNamespace getVariable ["mkk_ptg_mapCameraSpeedCtrls", []];
{
    if !(isNull _x) then {
        ctrlDelete _x;
    };
} forEach _speedCtrls;
missionNamespace setVariable ["mkk_ptg_mapCameraSpeedCtrls", []];

private _state = missionNamespace getVariable ["mkk_ptg_mapCameraState", createHashMap];
private _camera = _state getOrDefault ["camera", objNull];
if !(isNull _camera) then {
    _camera cameraEffect ["Terminate", "Back"];
    camDestroy _camera;
};
missionNamespace setVariable ["mkk_ptg_mapCameraState", createHashMap];
