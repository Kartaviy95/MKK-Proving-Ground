#include "..\script_component.hpp"

/*
    Открывает главное окно полигона.
*/
if !(hasInterface) exitWith {};
if !([player] call FUNC(isAuthorized)) exitWith {
    [localize "STR_MKK_PTG_NO_ACCESS"] call FUNC(showTimedHint);
};

private _fncQueueOpen = {
    if (uiNamespace getVariable ["mkk_ptg_mainDisplayOpenQueued", false]) exitWith {};

    uiNamespace setVariable ["mkk_ptg_mainDisplayOpenQueued", true];
    [] spawn {
        waitUntil {
            uiSleep 0.01;
            isNull (findDisplay 88000)
        };
        uiNamespace setVariable ["mkk_ptg_mainDisplayOpenQueued", false];
        uiNamespace setVariable ["mkk_ptg_mainDisplayClosing", false];

        if (isNull (findDisplay 88000)) then {
            [] call ptg_main_fnc_openMainUI;
        };
    };
};

private _display = findDisplay 88000;
if !(isNull _display) exitWith {
    private _trackedDisplay = uiNamespace getVariable ["mkk_ptg_display", displayNull];
    private _isLiveDisplay = !(isNull _trackedDisplay)
        && {uiNamespace getVariable ["mkk_ptg_webReady", false]}
        && {!(uiNamespace getVariable ["mkk_ptg_mainDisplayClosing", false])};

    if (_isLiveDisplay && {((diag_tickTime - (uiNamespace getVariable ["mkk_ptg_mainDisplayLastOpenedAt", -1])) < 0.35)}) then {
        // Ignore the same key press repeating into the freshly opened dialog.
    } else {
        uiNamespace setVariable ["mkk_ptg_mainDisplayClosing", true];
        _display closeDisplay 0;

        if !(_isLiveDisplay) then {
            call _fncQueueOpen;
        };
    };
};

uiNamespace setVariable ["mkk_ptg_mainDisplayClosing", false];
uiNamespace setVariable ["mkk_ptg_mainDisplayOpenQueued", false];
if (createDialog "MKK_PTG_MainDisplay") then {
    uiNamespace setVariable ["mkk_ptg_mainDisplayLastOpenedAt", diag_tickTime];
};
