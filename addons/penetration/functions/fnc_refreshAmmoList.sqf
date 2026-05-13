#include "..\script_component.hpp"
/*
    Заполняет список боеприпасов.
*/
private _display = uiNamespace getVariable ["mkk_ptg_penetrationDisplay", displayNull];
if (isNull _display) exitWith {};

private _ctrlSearch = _display displayCtrl 88911;
private _ctrlList = _display displayCtrl 88921;
private _search = toLower ctrlText _ctrlSearch;

lbClear _ctrlList;

{
    private _cfg = _x;
    private _className = configName _cfg;
    private _simulation = toLowerANSI ([_cfg, "simulation", ""] call EFUNC(common,getSafeConfigText));
    private _classNameLower = toLowerANSI _className;
    private _hit = [_cfg, "hit", 0] call EFUNC(common,getSafeConfigNumber);
    private _indirectHit = [_cfg, "indirectHit", 0] call EFUNC(common,getSafeConfigNumber);

    if !(_simulation in ["shotbullet", "shotshell", "shotrocket", "shotmissile"]) then {continue};
    if ("base" in _classNameLower) then {continue};
    if ((_hit + _indirectHit) <= 0) then {continue};

    private _displayName = [_cfg, "displayName", _className] call EFUNC(common,getSafeConfigText);
    _displayName = [_displayName] call EFUNC(common,localizeString);
    if (_displayName isEqualTo "") then {_displayName = _className;};

    if (_search isEqualTo "" || {(toLower _displayName) find _search > -1 || {(toLower _className) find _search > -1}}) then {
        private _idx = _ctrlList lbAdd format ["%1 | %2", _displayName, _className];
        _ctrlList lbSetData [_idx, _className];
    };
} forEach ("true" configClasses (configFile >> "CfgAmmo"));

if ((lbSize _ctrlList) > 0) then {
    _ctrlList lbSetCurSel 0;
    [_ctrlList, 0] call FUNC(onAmmoSelected);
} else {
    missionNamespace setVariable ["mkk_ptg_penetrationAmmoClass", ""];
    [] call FUNC(updateAmmoInfo);
};
