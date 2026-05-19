#include "..\script_component.hpp"
/*
    Переключает одну категорию hitpoint в инспекторе.
*/
params [["_setting", "", [""]]];

private _varName = switch (_setting) do {
    case "hpEngine": {"mkk_ptg_hitpointInspectorHpEngine"};
    case "hpHull": {"mkk_ptg_hitpointInspectorHpHull"};
    case "hpTurret": {"mkk_ptg_hitpointInspectorHpTurret"};
    case "hpGun": {"mkk_ptg_hitpointInspectorHpGun"};
    case "hpWheels": {"mkk_ptg_hitpointInspectorHpWheels"};
    case "hpTracks": {"mkk_ptg_hitpointInspectorHpTracks"};
    case "hpFuel": {"mkk_ptg_hitpointInspectorHpFuel"};
    default {""};
};

if (_varName isEqualTo "") exitWith {};

private _default = _setting in ["hpEngine", "hpHull", "hpTurret", "hpGun"];
private _enabled = !(missionNamespace getVariable [_varName, _default]);
missionNamespace setVariable [_varName, _enabled];

if !(isNull (findDisplay 88800)) exitWith {
    [] call FUNC(updateHitpointInspectorSettingsMenu);
};

[] call FUNC(updateHitpointInspectorSettingsMenu);

