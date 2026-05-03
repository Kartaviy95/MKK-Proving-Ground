#include "..\script_component.hpp"
/*
    Hides the vehicle rearm overlay.
*/
disableSerialization;

private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if (isNull _display) exitWith {};

{
    private _ctrl = _display displayCtrl _x;
    if (!isNull _ctrl) then {
        _ctrl ctrlShow false;
    };
} forEach [88200, 88201, 88202, 88203, 88204, 88205, 88206, 88207, 88220, 88221, 88222, 88230, 88231, 88232, 88233, 88240, 88241, 88242, 88243];

uiNamespace setVariable ["mkk_ptg_rearmOverlayVisible", false];
uiNamespace setVariable ["mkk_ptg_rearmVehicle", objNull];
uiNamespace setVariable ["mkk_ptg_rearmTurrets", []];
uiNamespace setVariable ["mkk_ptg_rearmSelectedTurret", []];
uiNamespace setVariable ["mkk_ptg_rearmSelectedWeapon", ""];
uiNamespace setVariable ["mkk_ptg_rearmSelectedMagazine", ""];
uiNamespace setVariable ["mkk_ptg_rearmCompatibleMagazines", []];
