#include "..\script_component.hpp"
/*
    Обновляет изображение и описание выбранной цели.
*/
private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if (isNull _display) exitWith {};

private _className = missionNamespace getVariable ["mkk_ptg_targetSelection", ""];
private _ctrlPic = _display displayCtrl 88330;
private _ctrlInfo = _display displayCtrl 88331;

if (_className isEqualTo "") exitWith {
    _ctrlPic ctrlSetText "";
    _ctrlInfo ctrlSetStructuredText parseText localize "STR_MKK_PTG_TARGET_SELECT_FIRST";
};

private _cfg = configFile >> "CfgVehicles" >> _className;
private _name = [_cfg, "displayName", _className] call EFUNC(common,getSafeConfigText);
_name = [_name] call EFUNC(common,localizeString);
if (_name isEqualTo "") then {_name = _className;};

private _preview = [_cfg] call EFUNC(common,getPreviewPath);
if (_preview isEqualTo "") then {_preview = [_cfg, "picture", ""] call EFUNC(common,getSafeConfigText);};
_ctrlPic ctrlSetText _preview;

private _text = format ["<t size='1.1'>%1</t><br/><br/>%2: %3", _name, localize "STR_MKK_PTG_CLASS", _className];
_ctrlInfo ctrlSetStructuredText parseText _text;
