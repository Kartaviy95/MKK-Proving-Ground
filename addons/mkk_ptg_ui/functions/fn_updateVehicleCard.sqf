/*
    Перерисовывает карточку выбранной техники.
*/
private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if (isNull _display) exitWith {};

private _className = missionNamespace getVariable ["mkk_ptg_currentSelection", ""];
private _ctrlInfo = _display displayCtrl 88031;

if (_className isEqualTo "") exitWith {
    _ctrlInfo ctrlSetStructuredText parseText "Выберите технику";
    [] call mkk_ptg_fnc_updateVehiclePreview;
};

private _info = [_className] call mkk_ptg_fnc_getVehicleInfo;
if (_info isEqualTo []) exitWith {
    _ctrlInfo ctrlSetStructuredText parseText "Информация не найдена";
    [] call mkk_ptg_fnc_updateVehiclePreview;
};

private _displayName = _info # 1;
private _sideId = _info # 2;
private _faction = _info # 3;
private _nation = _info # 4;
private _vehicleType = _info # 5;
private _crewClass = _info # 6;
private _modSource = _info # 10;

private _sideText = switch (_sideId) do {
    case 0: {"OPFOR"};
    case 1: {"BLUFOR"};
    case 2: {"Independent"};
    case 3: {"Civilian"};
    default {"Unknown"};
};

private _text = format [
    "<t size='1.1'>%1</t><br/><br/>Класс: %2<br/>Сторона: %3<br/>Фракция: %4<br/>Нация: %5<br/>Тип: %6<br/>Экипаж: %7<br/>Источник: %8",
    _displayName,
    _className,
    _sideText,
    _faction,
    _nation,
    _vehicleType,
    _crewClass,
    _modSource
];

_ctrlInfo ctrlSetStructuredText parseText _text;

[] call mkk_ptg_fnc_updateVehiclePreview;
