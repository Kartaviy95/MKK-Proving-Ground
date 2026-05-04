#include "..\script_component.hpp"
/*
    Открывает отдельное маленькое окно дополнительных настроек.
    Главное меню закрывается, чтобы настройки не рисовались поверх него и не мерцали.
*/
params [["_type", "", [""]]];

if !(hasInterface) exitWith {};
if !(_type in ["objectStatus", "mapProjectileMarker", "trajectory"]) exitWith {};

uiNamespace setVariable ["mkk_ptg_settingsDialogType", _type];
uiNamespace setVariable ["mkk_ptg_objectStatusSettingsVisible", _type isEqualTo "objectStatus"];
uiNamespace setVariable ["mkk_ptg_mapProjectileMarkerSettingsVisible", _type isEqualTo "mapProjectileMarker"];
uiNamespace setVariable ["mkk_ptg_trajectorySettingsVisible", _type isEqualTo "trajectory"];

[] spawn {
    disableSerialization;

    private _mainDisplay = findDisplay 88000;
    if !(isNull _mainDisplay) then {
        _mainDisplay closeDisplay 2;
        waitUntil {isNull (findDisplay 88000)};
    };

    private _settingsDisplay = findDisplay 88800;
    if (isNull _settingsDisplay) then {
        if !(createDialog "MKK_PTG_SettingsDisplay") then {
            [] call EFUNC(main,openMainUI);
        };
    } else {
        private _type = uiNamespace getVariable ["mkk_ptg_settingsDialogType", ""];
        switch (_type) do {
            case "objectStatus": {[] call FUNC(updateObjectStatusSettingsMenu)};
            case "mapProjectileMarker": {[] call FUNC(updateMapProjectileMarkerSettingsMenu)};
            case "trajectory": {[] call FUNC(updateTrajectorySettingsMenu)};
        };
    };
};
