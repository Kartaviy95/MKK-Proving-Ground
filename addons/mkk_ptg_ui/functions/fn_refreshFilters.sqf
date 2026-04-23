/*
    Заполняет фильтры и обновляет список техники.
*/
private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if (isNull _display) exitWith {};

private _catalog = missionNamespace getVariable ["mkk_ptg_catalogCache", []];
if (_catalog isEqualTo []) then {
    [] call mkk_ptg_fnc_buildVehicleCatalog;
    _catalog = missionNamespace getVariable ["mkk_ptg_catalogCache", []];
};

private _ctrlSide = _display displayCtrl 88011;
private _ctrlFaction = _display displayCtrl 88012;
private _ctrlNation = _display displayCtrl 88013;
private _ctrlType = _display displayCtrl 88014;

lbClear _ctrlSide;
lbClear _ctrlFaction;
lbClear _ctrlNation;
lbClear _ctrlType;

private _allSides = [[-1, "All"]];
private _allFactions = [""];
private _allNations = [""];
private _allTypes = [""];

{
    private _sideId = _x # 2;
    private _faction = _x # 3;
    private _nation = _x # 4;
    private _vehicleType = _x # 5;

    if ((_allSides findIf {(_x # 0) isEqualTo _sideId}) < 0) then {
        private _sideName = switch (_sideId) do {
            case 0: {"OPFOR"};
            case 1: {"BLUFOR"};
            case 2: {"Independent"};
            case 3: {"Civilian"};
            default {"Unknown"};
        };
        _allSides pushBack [_sideId, _sideName];
    };

    if !(_faction in _allFactions) then {_allFactions pushBack _faction;};
    if !(_nation in _allNations) then {_allNations pushBack _nation;};
    if !(_vehicleType in _allTypes) then {_allTypes pushBack _vehicleType;};
} forEach _catalog;

{
    private _idx = _ctrlSide lbAdd (_x # 1);
    _ctrlSide lbSetData [_idx, str (_x # 0)];
} forEach _allSides;

{
    private _label = if (_x isEqualTo "") then {"All"} else {_x};
    private _idx = _ctrlFaction lbAdd _label;
    _ctrlFaction lbSetData [_idx, _x];
} forEach _allFactions;

{
    private _label = if (_x isEqualTo "") then {"All"} else {_x};
    private _idx = _ctrlNation lbAdd _label;
    _ctrlNation lbSetData [_idx, _x];
} forEach _allNations;

{
    private _label = if (_x isEqualTo "") then {"All"} else {_x};
    private _idx = _ctrlType lbAdd _label;
    _ctrlType lbSetData [_idx, _x];
} forEach _allTypes;

_ctrlSide lbSetCurSel 0;
_ctrlFaction lbSetCurSel 0;
_ctrlNation lbSetCurSel 0;
_ctrlType lbSetCurSel 0;

[] call mkk_ptg_fnc_refreshVehicleList;
