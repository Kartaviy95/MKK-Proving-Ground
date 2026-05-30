#include "..\script_component.hpp"
/*
    Refreshes compatible ammo box options for the selected static weapon.
*/
private _className = missionNamespace getVariable ["mkk_ptg_currentSelection", ""];
uiNamespace setVariable ["mkk_ptg_vehicleAmmoBoxOptions", []];
missionNamespace setVariable ["mkk_ptg_currentAmmoBoxSelection", ""];

if (_className isEqualTo "" || {!(_className isKindOf "StaticWeapon")}) exitWith {};

private _spawnState = missionNamespace getVariable [
    "mkk_ptg_vehicleSpawnState",
    profileNamespace getVariable ["mkk_ptg_vehicleSpawnState", []]
];
if !(_spawnState isEqualType []) then {
    _spawnState = [];
};

private _savedClassName = _spawnState param [0, ""];
private _savedAmmoBoxClass = "";
if (_savedClassName isEqualTo _className) then {
    _savedAmmoBoxClass = _spawnState param [3, ""];
};

private _options = [["", localize "STR_MKK_PTG_NO_AMMO_BOX"]];
private _selection = "";
private _boxes = [_className] call EFUNC(catalog,getCompatibleAmmoBoxes);

if (_boxes isEqualTo []) exitWith {
    uiNamespace setVariable ["mkk_ptg_vehicleAmmoBoxOptions", [["", localize "STR_MKK_PTG_NO_COMPATIBLE_AMMO_BOXES"]]];
};

{
    _x params ["_boxClass", "_displayName", "_source"];
    _options pushBack [_boxClass, format ["%1 | %2", _displayName, _source]];
    if (_boxClass isEqualTo _savedAmmoBoxClass) then {
        _selection = _boxClass;
    };
} forEach _boxes;

uiNamespace setVariable ["mkk_ptg_vehicleAmmoBoxOptions", _options];
missionNamespace setVariable ["mkk_ptg_currentAmmoBoxSelection", _selection];
