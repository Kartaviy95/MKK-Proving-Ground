#include "..\script_component.hpp"
/*
    Закрывает меню создания целей.
*/
private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if (isNull _display) exitWith {};

uiNamespace setVariable ["mkk_ptg_targetOverlayVisible", false];
{
    (_display displayCtrl _x) ctrlShow false;
} forEach [
    88300, 88301, 88302, 88303, 88304, 88305, 88306, 88307, 88308, 88309,
    88310, 88311, 88315, 88316, 88317, 88318, 88320, 88330, 88331,
    88340, 88341, 88342
];

[] call FUNC(setDashboardControlsBlocked);
