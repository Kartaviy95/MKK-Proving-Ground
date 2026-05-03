#include "..\script_component.hpp"
/*
    Переключает одну настройку статус-дисплея объектов.
*/
params [["_setting", "", [""]]];

private _varName = switch (_setting) do {
    case "class": {"mkk_ptg_objectStatusShowClass"};
    case "distance": {"mkk_ptg_objectStatusShowDistance"};
    case "damage": {"mkk_ptg_objectStatusShowDamage"};
    case "hitpoints": {"mkk_ptg_objectStatusShowHitpoints"};
    case "hpHull": {"mkk_ptg_objectStatusHpHull"};
    case "hpEngine": {"mkk_ptg_objectStatusHpEngine"};
    case "hpFuel": {"mkk_ptg_objectStatusHpFuel"};
    case "hpTurret": {"mkk_ptg_objectStatusHpTurret"};
    case "hpGun": {"mkk_ptg_objectStatusHpGun"};
    default {""};
};

if (_varName isEqualTo "") exitWith {};

private _default = !(_setting in ["hitpoints"]);
private _enabled = !(missionNamespace getVariable [_varName, _default]);
missionNamespace setVariable [_varName, _enabled];

[] call FUNC(updateObjectStatusSettingsMenu);
