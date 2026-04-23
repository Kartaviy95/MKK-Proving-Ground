/*
    Обновляет изображение техники в карточке.
*/
private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if (isNull _display) exitWith {};

private _ctrlImage = _display displayCtrl 88030;
private _className = missionNamespace getVariable ["mkk_ptg_currentSelection", ""];
if (_className isEqualTo "") exitWith {
    _ctrlImage ctrlSetText "";
};

private _info = [_className] call mkk_ptg_fnc_getVehicleInfo;
if (_info isEqualTo []) exitWith {
    _ctrlImage ctrlSetText "";
};

private _previewPath = _info # 7;
private _picturePath = _info # 8;
private _finalPath = _previewPath;

if (_finalPath isEqualTo "") then {_finalPath = _picturePath;};
_ctrlImage ctrlSetText _finalPath;
