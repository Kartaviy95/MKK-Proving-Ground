#include "..\script_component.hpp"
/*
    Гарантирует включенное локальное измерение высоты точки на обычной карте.
    Отображается именно высота рельефа ASL по движку Arma 3 через
    getTerrainHeightASL, а не высота зданий или объектов.
*/
if !(hasInterface) exitWith {};

params [
    ["_showHint", true, [false]]
];

if (missionNamespace getVariable ["mkk_ptg_mapHeightSelecting", false]) then {
    missionNamespace setVariable ["mkk_ptg_mapHeightSelecting", false];
    onMapSingleClick "";

    if (missionNamespace getVariable ["mkk_ptg_mapHeightTemporaryMap", false]) then {
        player unlinkItem "ItemMap";
        missionNamespace setVariable ["mkk_ptg_mapHeightTemporaryMap", false];
    };
};

private _fncRemoveMapMissionEH = {
    private _mapEH = missionNamespace getVariable ["mkk_ptg_mapHeightMapMissionEH", -1];
    if (_mapEH >= 0) then {
        removeMissionEventHandler ["Map", _mapEH];
        missionNamespace setVariable ["mkk_ptg_mapHeightMapMissionEH", -1];
    };
};

missionNamespace setVariable ["mkk_ptg_mapHeightEnabled", true];
missionNamespace setVariable ["mkk_ptg_mapHeightSupervisorRunning", false];

if (_showHint) then {
    [localize "STR_MKK_PTG_MAP_HEIGHT_ENABLED"] call EFUNC(main,showTimedHint);
};
[] call _fncRemoveMapMissionEH;

private _mapEH = addMissionEventHandler ["Map", {
    params ["_mapIsOpened"];

    if !(_mapIsOpened) exitWith {
        [] call ptg_ui_fnc_detachMapHeightHandlers;
    };

    [] spawn {
        waitUntil {
            uiSleep 0.01;
            !isNull (findDisplay 12) || {!isNull (findDisplay 52)} || {!visibleMap}
        };

        if (isNull (findDisplay 12)) exitWith {};
        [] call ptg_ui_fnc_attachMapHeightHandlers;
    };
}];
missionNamespace setVariable ["mkk_ptg_mapHeightMapMissionEH", _mapEH];

if !(isNull (findDisplay 12)) then {
    [] call FUNC(attachMapHeightHandlers);
};
