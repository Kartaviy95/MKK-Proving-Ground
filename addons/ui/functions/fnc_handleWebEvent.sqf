#include "..\script_component.hpp"
/*
    Routes browser events into the established SQF action handlers.
*/
disableSerialization;
params ["_browser", "_isConfirmDialog", "_message"];

private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if (isNull _display) exitWith {true};

private _payload = _message;
if ((_payload select [0, 4]) isEqualTo "b64:") then {
    _payload = _browser ctrlWebBrowserAction ["FromBase64", _payload select [4]];
};

private _request = fromJSON _payload;
if !(_request isEqualType [] && {(count _request) >= 1}) exitWith {true};
private _action = _request # 0;
private _value = _request param [1, ""];
if !(_value isEqualType "") then {
    _value = str _value;
};

private _fncSelectData = {
    params ["_idc", "_data"];
    private _ctrl = _display displayCtrl _idc;
    private _index = -1;
    for "_i" from 0 to ((lbSize _ctrl) - 1) do {
        if ((_ctrl lbData _i) isEqualTo _data) exitWith {
            _index = _i;
        };
    };
    if (_index >= 0) then {
        _ctrl lbSetCurSel _index;
    };
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

private _fncSelectTargetFallback = {
    private _ctrl = _display displayCtrl 88320;
    if ((lbSize _ctrl) > 0) then {
        private _index = (lbCurSel _ctrl) max 0;
        [_ctrl, _index] call FUNC(onTargetSelected);
    };
};

private _fncPopulateRearmChildren = {
    params [["_slotIndex", -1]];
    private _slotCtrl = _display displayCtrl 88220;
    if (_slotIndex < 0) then {
        _slotIndex = (lbCurSel _slotCtrl) max 0;
    };
    if (_slotIndex < (lbSize _slotCtrl)) then {
        [_slotCtrl, _slotIndex] call FUNC(onRearmTurretSelected);
        private _weaponCtrl = _display displayCtrl 88221;
        if ((lbSize _weaponCtrl) > 0) then {
            [_weaponCtrl, 0] call FUNC(onRearmWeaponSelected);
            private _magCtrl = _display displayCtrl 88222;
            if ((lbSize _magCtrl) > 0) then {
                [_magCtrl, 0] call FUNC(onRearmMagazineSelected);
            };
        };
    };
};

switch (_action) do {
    case "close": {
        closeDialog 0;
    };
    case "dashboard": {
        [] call FUNC(closeTargetOverlay);
        [] call FUNC(closeRearmOverlay);
        [] call FUNC(showDashboardView);
    };
    case "vehicles": {
        [] call FUNC(showVehicleView);
    };
    case "targets": {
        [] call FUNC(openTargetOverlay);
        call _fncSelectTargetFallback;
    };
    case "rearm": {
        [] call FUNC(openRearmOverlay);
        if (uiNamespace getVariable ["mkk_ptg_rearmOverlayVisible", false]) then {
            [0] call _fncPopulateRearmChildren;
        };
    };
    case "teleport": {[] call FUNC(startTeleport)};
    case "camera": {[] call FUNC(startMapCamera)};
    case "unlock": {[] call EFUNC(main,unlockCursorVehicle)};
    case "cleanup": {[] call FUNC(onCleanupPressed)};
    case "tracking": {[] call FUNC(toggleTracking)};
    case "trajectory": {[] call EFUNC(tracking,toggleTrajectoryLines)};
    case "markers": {[] call EFUNC(tracking,toggleMapProjectileMarkers)};
    case "objectStatus": {[] call FUNC(toggleObjectStatusDisplay)};
    case "hitpoints": {[] call FUNC(toggleHitpointInspector)};
    case "infiniteAmmo": {[] call EFUNC(player,toggleInfiniteAmmo)};
    case "godMode": {[] call EFUNC(player,toggleGodMode)};
    case "explosion": {
        if !(isNil "ptg_penetration_fnc_openExplosionDisplay") then {
            [] call EFUNC(penetration,openExplosionDisplay);
        };
    };
    case "interfaceSize": {
        private _combo = _display displayCtrl 88131;
        private _index = -1;
        for "_i" from 0 to ((lbSize _combo) - 1) do {
            if ((str (_combo lbValue _i)) isEqualTo _value) exitWith {_index = _i};
        };
        if (_index >= 0) then {
            [_combo, _index] call FUNC(onInterfaceSizeSelected);
        };
    };
    case "focusNativeInput": {
        switch (_value) do {
            case "vehicleSearch": {[88010] call _fncFocusNativeInput};
            case "targetSearch": {[88311] call _fncFocusNativeInput};
        };
    };
    case "vehicleSearch": {
        (_display displayCtrl 88010) ctrlSetText _value;
        [] call FUNC(refreshVehicleList);
    };
    case "vehicleSide": {
        [88011, _value] call _fncSelectData;
        [] call FUNC(refreshVehicleList);
    };
    case "vehicleFaction": {
        [88012, _value] call _fncSelectData;
        [] call FUNC(refreshVehicleList);
    };
    case "vehicleType": {
        [88014, _value] call _fncSelectData;
        [] call FUNC(refreshVehicleList);
    };
    case "vehicleDistance": {
        (_display displayCtrl 88015) ctrlSetText _value;
        [false] call FUNC(saveVehicleSpawnState);
    };
    case "vehicleDirection": {
        (_display displayCtrl 88016) ctrlSetText _value;
        [false] call FUNC(saveVehicleSpawnState);
    };
    case "ammoBox": {
        private _selection = [88017, _value] call _fncSelectData;
        if ((_selection # 1) >= 0) then {
            _selection call FUNC(onStaticAmmoBoxSelected);
        };
    };
    case "selectVehicle": {
        private _selection = [88020, _value] call _fncSelectData;
        if ((_selection # 1) >= 0) then {
            _selection call FUNC(onVehicleSelected);
        };
    };
    case "spawnEmpty": {[false] call FUNC(onSpawnPressed)};
    case "spawnFullCrew": {[true] call FUNC(onSpawnPressed)};
    case "spawnCrewControl": {[] call FUNC(onSpawnCrewControlPressed)};
    case "copyVehicleClass": {[] call FUNC(onCopyClassPressed)};
    case "targetMode": {
        [88310, _value] call _fncSelectData;
        [] call FUNC(refreshTargetList);
        call _fncSelectTargetFallback;
    };
    case "targetSearch": {
        (_display displayCtrl 88311) ctrlSetText _value;
        [] call FUNC(refreshTargetList);
        call _fncSelectTargetFallback;
    };
    case "targetDistance": {(_display displayCtrl 88315) ctrlSetText _value};
    case "targetPatrol": {(_display displayCtrl 88316) ctrlSetText _value};
    case "targetAirRadius": {(_display displayCtrl 88317) ctrlSetText _value};
    case "targetAirHeight": {(_display displayCtrl 88318) ctrlSetText _value};
    case "selectTarget": {
        private _selection = [88320, _value] call _fncSelectData;
        if ((_selection # 1) >= 0) then {
            _selection call FUNC(onTargetSelected);
        };
    };
    case "spawnTarget": {[] call FUNC(onTargetSpawnPressed)};
    case "deleteTargets": {[] call FUNC(onDeleteTargetsPressed)};
    case "closeTargets": {[] call FUNC(closeTargetOverlay)};
    case "rearmSlot": {
        private _selection = [88220, _value] call _fncSelectData;
        if ((_selection # 1) >= 0) then {
            [_selection # 1] call _fncPopulateRearmChildren;
        };
    };
    case "rearmWeapon": {
        private _selection = [88221, _value] call _fncSelectData;
        if ((_selection # 1) >= 0) then {
            _selection call FUNC(onRearmWeaponSelected);
            private _magCtrl = _display displayCtrl 88222;
            if ((lbSize _magCtrl) > 0) then {
                [_magCtrl, 0] call FUNC(onRearmMagazineSelected);
            };
        };
    };
    case "rearmMagazine": {
        private _selection = [88222, _value] call _fncSelectData;
        if ((_selection # 1) >= 0) then {
            _selection call FUNC(onRearmMagazineSelected);
        };
    };
    case "loadMagazine": {
        [] call FUNC(loadSelectedRearmMagazine);
        [-1] call _fncPopulateRearmChildren;
    };
    case "clearWeapon": {
        [] call FUNC(clearSelectedRearmWeapon);
        [-1] call _fncPopulateRearmChildren;
    };
    case "copyMagazine": {[] call FUNC(copySelectedRearmMagazineClass)};
    case "closeRearm": {[] call FUNC(closeRearmOverlay)};
    case "setColor": {[parseNumber _value] call FUNC(setTrajectoryColor)};
    case "setWidth": {[parseNumber _value] call FUNC(setTrajectoryWidth)};
    case "markerAmmo": {[] call FUNC(toggleMapProjectileMarkerAmmoSetting)};
    case "objectSetting": {[_value] call FUNC(toggleObjectStatusSetting)};
    case "hitpointSetting": {[_value] call FUNC(toggleHitpointInspectorSetting)};
};

if !(isNull (uiNamespace getVariable ["mkk_ptg_display", displayNull])) then {
    [] call FUNC(pushWebState);
};
true
