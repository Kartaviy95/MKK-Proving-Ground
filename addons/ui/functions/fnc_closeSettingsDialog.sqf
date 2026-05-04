#include "..\script_component.hpp"
/*
    Закрывает окно дополнительных настроек и возвращает основное меню.
*/
params [["_openMainMenu", true, [true]]];

uiNamespace setVariable ["mkk_ptg_objectStatusSettingsVisible", false];
uiNamespace setVariable ["mkk_ptg_mapProjectileMarkerSettingsVisible", false];
uiNamespace setVariable ["mkk_ptg_trajectorySettingsVisible", false];
uiNamespace setVariable ["mkk_ptg_settingsDialogType", ""];

[] call FUNC(updateObjectStatusSettingsMenu);
[] call FUNC(updateMapProjectileMarkerSettingsMenu);
[] call FUNC(updateTrajectorySettingsMenu);

[_openMainMenu] spawn {
    params ["_openMainMenu"];
    disableSerialization;

    private _settingsDisplay = findDisplay 88800;
    if !(isNull _settingsDisplay) then {
        _settingsDisplay closeDisplay 2;
        waitUntil {isNull (findDisplay 88800)};
    };

    if (_openMainMenu) then {
        [] call EFUNC(main,openMainUI);
    };
};
