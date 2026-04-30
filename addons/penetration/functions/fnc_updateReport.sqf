#include "..\script_component.hpp"
/*
    Обновляет отчет в окне теста пробития.
*/
private _display = uiNamespace getVariable ["mkk_ptg_penetrationDisplay", displayNull];
private _report = missionNamespace getVariable ["mkk_ptg_penetrationReport", ""];
if (_report isEqualTo "") then {
    _report = localize "STR_MKK_PTG_DAMAGE_REPORT_EMPTY";
};

if !(isNull _display) then {
    private _ctrlReport = _display displayCtrl 88931;
    _ctrlReport ctrlSetStructuredText parseText _report;
};

private _hud = uiNamespace getVariable ["mkk_ptg_penetrationHud", displayNull];
if !(isNull _hud) then {
    private _ctrlHud = _hud displayCtrl 88980;
    _ctrlHud ctrlSetStructuredText parseText _report;
};
