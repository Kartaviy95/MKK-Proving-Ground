#include "..\script_component.hpp"
/*
    Заполняет список целей для overlay-меню.
*/
private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if (isNull _display) exitWith {};

private _ctrlMode = _display displayCtrl 88310;
private _mode = _ctrlMode lbData (lbCurSel _ctrlMode);
if (_mode isEqualTo "") then {_mode = "bot";};

private _ctrlSearch = _display displayCtrl 88311;
private _ctrlList = _display displayCtrl 88320;
private _search = toLowerANSI (ctrlText _ctrlSearch);
lbClear _ctrlList;

private _showGround = _mode isEqualTo "ground";
private _showAir = _mode isEqualTo "air";
private _lastMode = uiNamespace getVariable ["mkk_ptg_targetOverlayLastMode", ""];
if (_mode isNotEqualTo _lastMode) then {
    (_display displayCtrl 88315) ctrlSetText (["50", "5"] select (_mode isEqualTo "bot"));
    uiNamespace setVariable ["mkk_ptg_targetOverlayLastMode", _mode];
};
{
    (_display displayCtrl _x) ctrlShow _showGround;
} forEach [88305, 88316];
{
    (_display displayCtrl _x) ctrlShow _showAir;
} forEach [88306, 88307, 88317, 88318];

if (_mode isEqualTo "bot") then {
    {
        _x params ["_className", "_label"];
        if (_search isEqualTo "" || {(toLowerANSI _label) find _search > -1 || {(toLowerANSI _className) find _search > -1}}) then {
            private _idx = _ctrlList lbAdd _label;
            _ctrlList lbSetData [_idx, _className];
        };
    } forEach [
        ["O_Survivor_F", localize "STR_MKK_PTG_TARGET_RED_BOT"],
        ["B_Survivor_F", localize "STR_MKK_PTG_TARGET_BLUE_BOT"],
        ["I_Survivor_F", localize "STR_MKK_PTG_TARGET_GREEN_BOT"]
    ];
} else {
    private _catalog = missionNamespace getVariable ["mkk_ptg_catalogCache", []];
    if (_catalog isEqualTo []) then {
        [] call EFUNC(catalog,buildVehicleCatalog);
        _catalog = missionNamespace getVariable ["mkk_ptg_catalogCache", []];
    };

    private _playerSideId = switch (side (group player)) do {
        case west: {1};
        case east: {0};
        case independent: {2};
        default {1};
    };
    private _enemySideId = switch (_playerSideId) do {
        case 0: {1};
        case 1: {0};
        default {0};
    };

    private _filtered = _catalog select {
        private _className = _x # 0;
        private _displayName = [_x # 1] call EFUNC(common,localizeString);
        private _sideId = _x # 2;
        (_sideId isEqualTo _enemySideId)
        && (
            (_showGround && {_className isKindOf "LandVehicle"})
            || {_showAir && {_className isKindOf "Air"}}
        )
        && (_search isEqualTo "" || {(toLowerANSI _displayName) find _search > -1 || {(toLowerANSI _className) find _search > -1}})
    };

    {
        private _className = _x # 0;
        private _displayName = [_x # 1] call EFUNC(common,localizeString);
        private _vehicleType = [_x # 4] call EFUNC(common,localizeString);
        private _idx = _ctrlList lbAdd format ["%1 | %2", _displayName, _vehicleType];
        _ctrlList lbSetData [_idx, _className];
    } forEach _filtered;
};

if ((lbSize _ctrlList) > 0) then {
    _ctrlList lbSetCurSel 0;
} else {
    missionNamespace setVariable ["mkk_ptg_targetSelection", ""];
    [] call FUNC(updateTargetPreview);
};
