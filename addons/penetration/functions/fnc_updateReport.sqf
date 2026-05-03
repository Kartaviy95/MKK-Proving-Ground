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
    private _hudScales = [] call EFUNC(common,getHudScale);
    private _hudScale = _hudScales # 0;
    private _fontScale = _hudScales # 1;

    private _reportRect = [[0.68, 0.04, 0.30, 0.34], _hudScale] call EFUNC(common,scaleRect);
    private _hintRect = [[0.68, 0.39, 0.30, 0.06], _hudScale] call EFUNC(common,scaleRect);

    private _ctrlHud = _hud displayCtrl 88980;
    if !(isNull _ctrlHud) then {
        _ctrlHud ctrlSetPosition _reportRect;
        _ctrlHud ctrlCommit 0;
        _ctrlHud ctrlSetStructuredText parseText format ["<t size='%1'>%2</t>", str ([1 * _fontScale, 2] call BIS_fnc_cutDecimals), _report];
    };

    private _ctrlHint = _hud displayCtrl 88981;
    if !(isNull _ctrlHint) then {
        _ctrlHint ctrlSetPosition _hintRect;
        _ctrlHint ctrlCommit 0;
        _ctrlHint ctrlSetStructuredText parseText format [
            "<t size='%1'>%2</t>",
            str ([0.92 * _fontScale, 2] call BIS_fnc_cutDecimals),
            localize "STR_MKK_PTG_ORBIT_EXIT_HINT"
        ];
    };
};
