#include "..\script_component.hpp"
/*
    Executes browser actions through the pre-existing penetration UI handlers.
*/
disableSerialization;
params ["_browser", "_isConfirmDialog", "_message"];

private _surface = _browser getVariable ["mkk_ptg_webSurface", "penetration"];
private _isExplosion = _surface isEqualTo "explosion";
private _display = uiNamespace getVariable [
    ["mkk_ptg_penetrationDisplay", "mkk_ptg_explosionDisplay"] select _isExplosion,
    displayNull
];
if (isNull _display) exitWith {true};

private _payload = _message;
if ((_payload select [0, 4]) isEqualTo "b64:") then {
    _payload = _browser ctrlWebBrowserAction ["FromBase64", _payload select [4]];
};

private _request = fromJSON _payload;
if !(_request isEqualType [] && {(count _request) >= 1}) exitWith {true};
private _action = _request # 0;
private _value = _request param [1, ""];
if !(_value isEqualType "") then {_value = str _value};

private _fncSelectData = {
    params ["_idc", "_data"];
    private _ctrl = _display displayCtrl _idc;
    private _index = -1;
    for "_i" from 0 to ((lbSize _ctrl) - 1) do {
        if ((_ctrl lbData _i) isEqualTo _data) exitWith {_index = _i};
    };
    if (_index >= 0) then {_ctrl lbSetCurSel _index};
    [_ctrl, _index]
};

private _fncFocusNativeInput = {
    params ["_idc"];
    private _control = _display displayCtrl _idc;
    if (isNull _control) exitWith {};

    // Use native text input for IME/Cyrillic support without exposing the legacy control.
    _control ctrlSetPosition [safeZoneX - safeZoneW, safeZoneY - safeZoneH, 0.001, 0.001];
    _control ctrlSetFade 1;
    _control ctrlCommit 0;
    _control ctrlShow true;
    _control ctrlSetTextSelection [count (ctrlText _control), 0];
    ctrlSetFocus _control;
};

switch (_action) do {
    case "focusNativeInput": {
        switch (_value) do {
            case "penVehicleSearch": {[88910] call _fncFocusNativeInput};
            case "penAmmoSearch": {[88911] call _fncFocusNativeInput};
            case "explosionSearch": {[89010] call _fncFocusNativeInput};
        };
    };
    case "penVehicleSearch": {
        (_display displayCtrl 88910) ctrlSetText _value;
        [] call FUNC(refreshVehicleList);
    };
    case "penAmmoSearch": {
        (_display displayCtrl 88911) ctrlSetText _value;
        [] call FUNC(refreshAmmoList);
    };
    case "penVehicle": {
        private _selection = [88920, _value] call _fncSelectData;
        if ((_selection # 1) >= 0) then {_selection call FUNC(onVehicleSelected)};
    };
    case "penAmmo": {
        private _selection = [88921, _value] call _fncSelectData;
        if ((_selection # 1) >= 0) then {_selection call FUNC(onAmmoSelected)};
    };
    case "penCreateTarget": {[] call FUNC(serverCreateTarget)};
    case "penOrbit": {[] call FUNC(startOrbitCamera)};
    case "penFire": {[] call FUNC(createTestShot)};
    case "penCopyAmmo": {[] call FUNC(onCopyAmmoClassPressed)};
    case "penReset": {[] call FUNC(resetTest)};
    case "penBack": {[] call FUNC(backToDashboard)};
    case "explosionSearch": {
        (_display displayCtrl 89010) ctrlSetText _value;
        [] call FUNC(refreshExplosionAmmoList);
    };
    case "explosionCategory": {
        [89011, _value] call _fncSelectData;
        [] call FUNC(refreshExplosionAmmoList);
    };
    case "explosionAmmo": {
        private _selection = [89020, _value] call _fncSelectData;
        if ((_selection # 1) >= 0) then {_selection call FUNC(onExplosionAmmoSelected)};
    };
    case "explosionHeight": {
        (_display displayCtrl 89031) ctrlSetText _value;
    };
    case "explosionBack": {[] call FUNC(backToDashboard)};
    case "explosionClose": {closeDialog 0};
};

private _activeDisplay = uiNamespace getVariable [
    ["mkk_ptg_penetrationDisplay", "mkk_ptg_explosionDisplay"] select _isExplosion,
    displayNull
];
if !(isNull _activeDisplay) then {
    [_surface] call FUNC(pushWebState);
};
true
