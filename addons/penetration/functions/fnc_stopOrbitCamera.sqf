#include "..\script_component.hpp"
/*
    Останавливает orbit-камеру.
*/
missionNamespace setVariable ["mkk_ptg_penetrationCameraRunning", false];
missionNamespace setVariable ["mkk_ptg_penetrationClosingForCamera", false];

private _display = findDisplay 46;
private _ehs = missionNamespace getVariable ["mkk_ptg_penetrationOrbitControlEHs", []];
if !(isNull _display) then {
    if ((count _ehs) > 0) then {_display displayRemoveEventHandler ["MouseMoving", _ehs # 0];};
    if ((count _ehs) > 1) then {_display displayRemoveEventHandler ["MouseZChanged", _ehs # 1];};
    if ((count _ehs) > 2) then {_display displayRemoveEventHandler ["KeyDown", _ehs # 2];};
};
missionNamespace setVariable ["mkk_ptg_penetrationOrbitControlEHs", []];
missionNamespace setVariable ["mkk_ptg_penetrationOrbitControlsAdded", false];

private _state = missionNamespace getVariable ["mkk_ptg_penetrationCameraState", createHashMap];
private _camera = _state getOrDefault ["camera", objNull];

if !(isNull _camera) then {
    _camera cameraEffect ["Terminate", "Back"];
    camDestroy _camera;
};

private _hud = uiNamespace getVariable ["mkk_ptg_penetrationHud", displayNull];
if !(isNull _hud) then {
    (_hud displayCtrl 88980) ctrlSetStructuredText parseText "";
    (_hud displayCtrl 88981) ctrlSetStructuredText parseText "";
};

private _hudLayer = "mkk_ptg_penetrationHudLayer" call BIS_fnc_rscLayer;
_hudLayer cutText ["", "PLAIN"];
uiNamespace setVariable ["mkk_ptg_penetrationHud", displayNull];

missionNamespace setVariable ["mkk_ptg_penetrationCameraState", createHashMap];
