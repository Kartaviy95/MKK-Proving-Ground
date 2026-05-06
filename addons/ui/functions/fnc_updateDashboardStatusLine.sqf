#include "..\script_component.hpp"
/*
    Обновляет нижнюю строку статусов для toggle-функций dashboard.
*/
disableSerialization;

private _display = uiNamespace getVariable ["mkk_ptg_display", displayNull];
if (isNull _display) exitWith {};

private _ctrl = _display displayCtrl 88151;
if (isNull _ctrl) exitWith {};

private _fncStateText = {
    params ["_enabled"];

    private _text = [localize "STR_MKK_PTG_STATUS_OFF", localize "STR_MKK_PTG_STATUS_ON"] select _enabled;
    private _color = ["#FF5C5C", "#69E06D"] select _enabled;
    format ["<t color='%2'>%1</t>", _text, _color]
};

private _items = [
    [localize "STR_MKK_PTG_STATUS_TRACKING", missionNamespace getVariable ["mkk_ptg_trackingEnabled", false]],
    [localize "STR_MKK_PTG_STATUS_TRAJECTORY", missionNamespace getVariable ["mkk_ptg_trajectoryEnabled", false]],
    [localize "STR_MKK_PTG_STATUS_MAP_MARKERS", missionNamespace getVariable ["mkk_ptg_mapProjectileMarkersEnabled", false]],
    [localize "STR_MKK_PTG_STATUS_OBJECT_STATUS", missionNamespace getVariable ["mkk_ptg_objectStatusDisplayEnabled", false]],
    [localize "STR_MKK_PTG_STATUS_HITPOINTS", missionNamespace getVariable ["mkk_ptg_hitpointInspectorEnabled", false]],
    [localize "STR_MKK_PTG_STATUS_INFINITE_AMMO", missionNamespace getVariable ["mkk_ptg_infiniteAmmoEnabled", false]],
    [localize "STR_MKK_PTG_STATUS_GOD_MODE", missionNamespace getVariable ["mkk_ptg_godModeEnabled", false]]
];

private _parts = [];
{
    _x params ["_label", "_enabled"];
    _parts pushBack format ["%1: %2", _label, [_enabled] call _fncStateText];
} forEach _items;

_ctrl ctrlSetStructuredText parseText (_parts joinString " | ");
