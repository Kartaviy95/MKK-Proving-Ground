#include "..\script_component.hpp"
/*
    Открывает overlay перевооружения техники поверх главного меню.
*/
disableSerialization;

private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if (isNull _display) exitWith {};

private _vehicle = objectParent player;
if (isNull _vehicle) exitWith {
    [localize "STR_MKK_PTG_REARM_ENTER_VEHICLE"] call EFUNC(main,showTimedHint);
};

[] call FUNC(closeTargetOverlay);
uiNamespace setVariable ["mkk_ptg_rearmOverlayVisible", true];
[] call FUNC(setDashboardControlsBlocked);

{
    private _ctrl = _display displayCtrl _x;
    if (!isNull _ctrl) then {
        _ctrl ctrlShow true;
    };
} forEach [88200, 88201, 88202, 88203, 88204, 88205, 88206, 88207, 88220, 88221, 88222, 88230, 88231, 88232, 88233, 88240, 88241, 88242, 88243];

[] call FUNC(refreshRearmOverlay);
