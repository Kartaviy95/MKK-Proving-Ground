#include "..\script_component.hpp"
/*
    Останавливает локальную камеру tracking-системы.
*/
private _state = missionNamespace getVariable ["mkk_ptg_trackingState", createHashMap];
if (_state isEqualType createHashMap && {count _state > 0}) then {
    private _camera = _state getOrDefault ["camera", objNull];
    if !(isNull _camera) then {
        detach _camera;
        _camera cameraEffect ["Terminate", "Back"];
        camDestroy _camera;
    };
};

private _display = findDisplay 46;
private _keyEH = missionNamespace getVariable ["mkk_ptg_trackingKeyEH", -1];
if !(isNull _display) then {
    if (_keyEH >= 0) then {
        _display displayRemoveEventHandler ["KeyDown", _keyEH];
    };
};
missionNamespace setVariable ["mkk_ptg_trackingKeyEH", -1];

private _hud = uiNamespace getVariable ["mkk_ptg_trackingHud", displayNull];
if !(isNull _hud) then {
    (_hud displayCtrl 88302) ctrlSetStructuredText parseText "";
};

private _hudLayer = "mkk_ptg_trackingHudLayer" call BIS_fnc_rscLayer;
_hudLayer cutText ["", "PLAIN"];
uiNamespace setVariable ["mkk_ptg_trackingHud", displayNull];

hintSilent "";
missionNamespace setVariable ["mkk_ptg_trackingState", createHashMap];
