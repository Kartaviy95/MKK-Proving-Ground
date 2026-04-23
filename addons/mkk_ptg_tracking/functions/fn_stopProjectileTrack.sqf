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

hintSilent "";
missionNamespace setVariable ["mkk_ptg_trackingState", createHashMap];
