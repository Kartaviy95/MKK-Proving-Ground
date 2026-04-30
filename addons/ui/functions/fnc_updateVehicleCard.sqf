#include "..\script_component.hpp"
/*
    Перерисовывает карточку выбранной техники.
*/
private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if (isNull _display) exitWith {};

private _className = missionNamespace getVariable ["mkk_ptg_currentSelection", ""];
private _ctrlInfo = _display displayCtrl 88031;

if (_className isEqualTo "") exitWith {
    _ctrlInfo ctrlSetStructuredText parseText localize "STR_MKK_PTG_SELECT_VEHICLE";
    [] call FUNC(updateVehiclePreview);
};

private _info = [_className] call EFUNC(catalog,getVehicleInfo);
if (_info isEqualTo []) exitWith {
    _ctrlInfo ctrlSetStructuredText parseText localize "STR_MKK_PTG_INFO_NOT_FOUND";
    [] call FUNC(updateVehiclePreview);
};

private _displayName = [_info # 1] call EFUNC(common,localizeString);
private _sideId = _info # 2;
private _faction = _info # 3;
private _vehicleType = _info # 4;
private _crewClass = _info # 5;
private _modSource = _info # 9;
private _factionDisplayName = _info param [11, _faction];
private _groupDisplayName = _info param [12, _info # 8];

private _sideText = switch (_sideId) do {
    case 0: {localize "STR_MKK_PTG_OPFOR"};
    case 1: {localize "STR_MKK_PTG_BLUFOR"};
    case 2: {localize "STR_MKK_PTG_INDEPENDENT"};
    case 3: {localize "STR_MKK_PTG_CIVILIAN"};
    default {localize "STR_MKK_PTG_UNKNOWN"};
};

private _text = format [
    "<t size='1.1'>%1</t><br/><br/>%9: %2<br/>%10: %3<br/>%11: %4<br/>%12: %5<br/>%13: %6<br/>%14: %7<br/>%15: %8",
    _displayName,
    _className,
    _sideText,
    _factionDisplayName,
    [_vehicleType] call EFUNC(common,localizeString),
    _groupDisplayName,
    _crewClass,
    _modSource,
    localize "STR_MKK_PTG_CLASS",
    localize "STR_MKK_PTG_SIDE",
    localize "STR_MKK_PTG_FACTION",
    localize "STR_MKK_PTG_TYPE",
    localize "STR_MKK_PTG_GROUP",
    localize "STR_MKK_PTG_CREW",
    localize "STR_MKK_PTG_SOURCE"
];

_ctrlInfo ctrlSetStructuredText parseText _text;

[] call FUNC(updateVehiclePreview);
