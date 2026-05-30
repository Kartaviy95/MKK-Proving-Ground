#include "..\script_component.hpp"
/*
    Refreshes the target rows for the browser target screen.
*/
private _mode = uiNamespace getVariable ["mkk_ptg_targetMode", "bot"];
if !(_mode in ["bot", "ground", "air"]) then {_mode = "bot";};
uiNamespace setVariable ["mkk_ptg_targetMode", _mode];

private _search = toLower (uiNamespace getVariable ["mkk_ptg_targetSearch", ""]);
private _showGround = _mode isEqualTo "ground";
private _showAir = _mode isEqualTo "air";
private _lastMode = uiNamespace getVariable ["mkk_ptg_targetOverlayLastMode", ""];
if (_mode isNotEqualTo _lastMode) then {
    uiNamespace setVariable ["mkk_ptg_targetDistance", (["50", "5"] select (_mode isEqualTo "bot"))];
    uiNamespace setVariable ["mkk_ptg_targetOverlayLastMode", _mode];
};

private _rows = [];
if (_mode isEqualTo "bot") then {
    {
        _x params ["_className", "_label"];
        if (_search isEqualTo "" || {(toLower _label) find _search > -1 || {(toLower _className) find _search > -1}}) then {
            _rows pushBack [_className, _label, ""];
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

    {
        private _className = _x # 0;
        private _displayName = [_x # 1] call EFUNC(common,localizeString);
        private _sideId = _x # 2;
        if (
            (_sideId isEqualTo _enemySideId)
            && (
                (_showGround && {_className isKindOf "LandVehicle"})
                || {_showAir && {_className isKindOf "Air"}}
            )
            && (_search isEqualTo "" || {(toLower _displayName) find _search > -1 || {(toLower _className) find _search > -1}})
        ) then {
            private _vehicleType = [_x # 4] call EFUNC(common,localizeString);
            _rows pushBack [_className, _displayName, _vehicleType];
        };
    } forEach _catalog;
};

uiNamespace setVariable ["mkk_ptg_targetRows", _rows];
if (_rows isNotEqualTo []) then {
    private _selected = missionNamespace getVariable ["mkk_ptg_targetSelection", ""];
    if ((_rows findIf {(_x # 0) isEqualTo _selected}) < 0) then {
        missionNamespace setVariable ["mkk_ptg_targetSelection", (_rows # 0) # 0];
    };
} else {
    missionNamespace setVariable ["mkk_ptg_targetSelection", ""];
};
