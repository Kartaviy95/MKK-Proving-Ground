#include "..\script_component.hpp"
/*
    Обновляет изображение выбранной техники в тесте пробития.
*/
private _display = uiNamespace getVariable ["mkk_ptg_penetrationDisplay", displayNull];
if (isNull _display) exitWith {};

private _ctrlImage = _display displayCtrl 88930;
private _className = missionNamespace getVariable ["mkk_ptg_penetrationVehicleClass", ""];
if (_className isEqualTo "") exitWith {
    _ctrlImage ctrlSetText "";
};

private _info = [_className] call EFUNC(catalog,getVehicleInfo);
if (_info isEqualTo []) exitWith {
    _ctrlImage ctrlSetText "";
};

private _previewPath = _info param [6, ""];
private _picturePath = _info param [7, ""];
private _finalPath = _previewPath;

if (_finalPath isEqualTo "") then {_finalPath = _picturePath;};
_ctrlImage ctrlSetText _finalPath;
