#include "..\script_component.hpp"
/*
    Открывает меню создания целей поверх главного окна.
*/
private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if (isNull _display) exitWith {};

[] call FUNC(closeRearmOverlay);
uiNamespace setVariable ["mkk_ptg_targetOverlayVisible", true];
uiNamespace setVariable ["mkk_ptg_targetOverlayLastMode", ""];

{
    (_display displayCtrl _x) ctrlShow true;
} forEach [
    88300, 88301, 88302, 88303, 88304, 88305, 88306, 88307, 88308, 88309,
    88310, 88311, 88315, 88316, 88317, 88318, 88320, 88330, 88331,
    88340, 88341, 88342
];

private _ctrlMode = _display displayCtrl 88310;
if ((lbSize _ctrlMode) isEqualTo 0) then {
    private _idx = _ctrlMode lbAdd localize "STR_MKK_PTG_TARGET_BOTS";
    _ctrlMode lbSetData [_idx, "bot"];
    _idx = _ctrlMode lbAdd localize "STR_MKK_PTG_TARGET_GROUND";
    _ctrlMode lbSetData [_idx, "ground"];
    _idx = _ctrlMode lbAdd localize "STR_MKK_PTG_TARGET_AIR";
    _ctrlMode lbSetData [_idx, "air"];
    _ctrlMode lbSetCurSel 0;
};

(_display displayCtrl 88315) ctrlSetText "5";
if ((ctrlText (_display displayCtrl 88316)) isEqualTo "") then {(_display displayCtrl 88316) ctrlSetText "50";};
if ((ctrlText (_display displayCtrl 88317)) isEqualTo "") then {(_display displayCtrl 88317) ctrlSetText "150";};
if ((ctrlText (_display displayCtrl 88318)) isEqualTo "") then {(_display displayCtrl 88318) ctrlSetText "100";};

[] call FUNC(refreshTargetList);
[] call FUNC(setDashboardControlsBlocked);
