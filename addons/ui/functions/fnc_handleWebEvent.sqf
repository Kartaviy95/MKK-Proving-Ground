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

private _shouldPushState = true;

switch (_action) do {
    case "close": {
        _shouldPushState = false;
        uiNamespace setVariable ["mkk_ptg_mainDisplayClosing", true];
        uiNamespace setVariable ["mkk_ptg_webReady", false];
        _display closeDisplay 0;
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
    };
    case "rearm": {
        [] call FUNC(openRearmOverlay);
    };
    case "teleport": {
        _shouldPushState = false;
        uiNamespace setVariable ["mkk_ptg_mainDisplayClosing", true];
        uiNamespace setVariable ["mkk_ptg_webReady", false];
        [] call FUNC(startTeleport);
    };
    case "camera": {
        _shouldPushState = false;
        uiNamespace setVariable ["mkk_ptg_mainDisplayClosing", true];
        uiNamespace setVariable ["mkk_ptg_webReady", false];
        [] call FUNC(startMapCamera);
    };
    case "mapTimingStart": {
        _shouldPushState = false;

        private _payload = createHashMap;
        if (_value isNotEqualTo "") then {
            private _decoded = fromJSON _value;
            if (_decoded isEqualType createHashMap) then {
                _payload = _decoded;
            };
        };

        private _color = _payload getOrDefault ["color", "ColorBlack"];
        if !(_color isEqualType "") then {_color = "ColorBlack";};

        [_color] call FUNC(startMapTiming);
    };
    case "mapTimingToggle": {
        if (missionNamespace getVariable ["mkk_ptg_mapTimingActive", false]) then {
            [] call FUNC(stopMapTiming);
        } else {
            _shouldPushState = false;

            private _payload = createHashMap;
            if (_value isNotEqualTo "") then {
                private _decoded = fromJSON _value;
                if (_decoded isEqualType createHashMap) then {
                    _payload = _decoded;
                };
            };

            private _color = _payload getOrDefault ["color", "ColorBlack"];
            if !(_color isEqualType "") then {_color = "ColorBlack";};

            [_color] call FUNC(startMapTiming);
        };
    };
    case "mapTimingStop": {
        [] call FUNC(stopMapTiming);
    };
    case "mapTimingClear": {
        [] call FUNC(clearMapTimings);
    };
    case "mapSmokeColor": {
        [_value] call FUNC(setMapSmokeColor);
    };
    case "mapHeightMarkerColor": {
        [_value] call FUNC(setMapHeightMarkerColor);
    };
    case "mapHeight": {
        [] call FUNC(startMapHeightProbe);
    };
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
            _shouldPushState = false;
            uiNamespace setVariable ["mkk_ptg_mainDisplayClosing", true];
            uiNamespace setVariable ["mkk_ptg_webReady", false];
            [] call EFUNC(penetration,openExplosionDisplay);
        };
    };
    case "interfaceSize": {
        [parseNumber _value] call FUNC(onInterfaceSizeSelected);
    };
    case "vehicleSearch": {
        uiNamespace setVariable ["mkk_ptg_vehicleSearch", _value];
        [] call FUNC(refreshVehicleList);
    };
    case "vehicleSide": {
        uiNamespace setVariable ["mkk_ptg_vehicleFilterSide", parseNumber _value];
        [] call FUNC(refreshVehicleList);
    };
    case "vehicleFaction": {
        uiNamespace setVariable ["mkk_ptg_vehicleFilterFaction", _value];
        [] call FUNC(refreshVehicleList);
    };
    case "vehicleType": {
        uiNamespace setVariable ["mkk_ptg_vehicleFilterType", _value];
        [] call FUNC(refreshVehicleList);
    };
    case "vehicleDistance": {
        uiNamespace setVariable ["mkk_ptg_vehicleDistance", _value];
        [false] call FUNC(saveVehicleSpawnState);
    };
    case "vehicleDirection": {
        uiNamespace setVariable ["mkk_ptg_vehicleDirection", _value];
        [false] call FUNC(saveVehicleSpawnState);
    };
    case "ammoBox": {
        [_value] call FUNC(onStaticAmmoBoxSelected);
    };
    case "selectVehicle": {
        [_value] call FUNC(onVehicleSelected);
    };
    case "spawnEmpty": {[false] call FUNC(onSpawnPressed)};
    case "spawnFullCrew": {[true] call FUNC(onSpawnPressed)};
    case "spawnCrewControl": {[] call FUNC(onSpawnCrewControlPressed)};
    case "copyVehicleClass": {[] call FUNC(onCopyClassPressed)};
    case "targetMode": {
        uiNamespace setVariable ["mkk_ptg_targetMode", _value];
        [] call FUNC(refreshTargetList);
    };
    case "targetSearch": {
        uiNamespace setVariable ["mkk_ptg_targetSearch", _value];
        [] call FUNC(refreshTargetList);
    };
    case "targetDistance": {uiNamespace setVariable ["mkk_ptg_targetDistance", _value]};
    case "targetPatrol": {uiNamespace setVariable ["mkk_ptg_targetPatrol", _value]};
    case "targetAirRadius": {uiNamespace setVariable ["mkk_ptg_targetAirRadius", _value]};
    case "targetAirHeight": {uiNamespace setVariable ["mkk_ptg_targetAirHeight", _value]};
    case "selectTarget": {
        [_value] call FUNC(onTargetSelected);
    };
    case "spawnTarget": {[] call FUNC(onTargetSpawnPressed)};
    case "deleteTargets": {[] call FUNC(onDeleteTargetsPressed)};
    case "closeTargets": {[] call FUNC(closeTargetOverlay)};
    case "rearmSlot": {
        [parseNumber _value] call FUNC(onRearmTurretSelected);
    };
    case "rearmWeapon": {
        [parseNumber _value] call FUNC(onRearmWeaponSelected);
    };
    case "rearmMagazine": {
        [parseNumber _value] call FUNC(onRearmMagazineSelected);
    };
    case "loadMagazine": {
        [] call FUNC(loadSelectedRearmMagazine);
    };
    case "clearWeapon": {
        [] call FUNC(clearSelectedRearmWeapon);
    };
    case "copyMagazine": {[] call FUNC(copySelectedRearmMagazineClass)};
    case "closeRearm": {[] call FUNC(closeRearmOverlay)};
    case "setColor": {[parseNumber _value] call FUNC(setTrajectoryColor)};
    case "setWidth": {[parseNumber _value] call FUNC(setTrajectoryWidth)};
    case "markerAmmo": {[] call FUNC(toggleMapProjectileMarkerAmmoSetting)};
    case "objectSetting": {[_value] call FUNC(toggleObjectStatusSetting)};
    case "hitpointSetting": {[_value] call FUNC(toggleHitpointInspectorSetting)};
};

if (_shouldPushState && {!(isNull (uiNamespace getVariable ["mkk_ptg_display", displayNull]))}) then {
    [] call FUNC(pushWebState);
};
true
